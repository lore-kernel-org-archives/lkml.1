Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYHBOCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYHBOCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYHBOCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:02:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60328 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbYHBOCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:02:43 -0400
Date: Sat, 2 Aug 2008 09:02:41 -0500
From: Paul Jackson <pj@sgi.com>
To: Alexey Dobriyan <adobriyan@gmail.com>, Mike Travis <travis@sgi.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add seq_cpumask(), seq_nodemask()
Message-Id: <20080802090241.8a989016.pj@sgi.com>
In-Reply-To: <20080802112828.GA3536@martell.zuzino.mipt.ru>
References: <20080802112828.GA3536@martell.zuzino.mipt.ru>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike - this patch and the next one in this series from Alexey
look like they would be of interest to you.

Alexey - I recommend you add Mike to the CC list, if there is
further work on these particular patches.

At first glance, this looks good - thanks.

Reviewed-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
