Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXITU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXITU4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXITU4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:56:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52973 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751012AbXITU4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:56:04 -0400
Message-ID: <46F2DC5A.3030500@sgi.com>
Date: Thu, 20 Sep 2007 13:47:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Convert cpuinfo_x86 array to a per_cpu array
References: <20070920204932.663196000@sgi.com> <20070920204932.927174000@sgi.com>
In-Reply-To: <20070920204932.927174000@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

travis@sgi.com wrote:

> 
> This patch is based on 2.6.23-rc6 with the prior per_cpu patches
> applied.  I can also provide a version based on 2.6.23-rc4-mm1 
> which has some different changes.
> 

I just noticed that 2.6.23-rc6-mm1 is now available.  I will rebase
this patch on that version as there are some significant differences.
