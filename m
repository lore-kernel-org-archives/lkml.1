Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYHDNdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYHDNdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYHDNd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:33:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49368 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753377AbYHDNd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:33:29 -0400
Message-ID: <48970528.2050404@sgi.com>
Date: Mon, 04 Aug 2008 06:33:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add seq_cpumask(), seq_nodemask()
References: <20080802112828.GA3536@martell.zuzino.mipt.ru> <20080802090241.8a989016.pj@sgi.com>
In-Reply-To: <20080802090241.8a989016.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Mike - this patch and the next one in this series from Alexey
> look like they would be of interest to you.
> 
> Alexey - I recommend you add Mike to the CC list, if there is
> further work on these particular patches.
> 
> At first glance, this looks good - thanks.
> 
> Reviewed-by: Paul Jackson <pj@sgi.com>
> 

Yes, it does... thanks!

Might need something similar for cpulist_scnprintf to handle the
worst case (every other cpu enabled).

Mike
