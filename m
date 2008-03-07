Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYCGLCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYCGLCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYCGLCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:02:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:37991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbYCGLCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:02:12 -0500
Date: Fri, 7 Mar 2008 12:02:06 +0100
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce initial apicid
Message-ID: <20080307110206.GI9021@bingen.suse.de>
References: <86802c440803061346u350d395djacf5e1aefffb0e4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803061346u350d395djacf5e1aefffb0e4b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 01:46:39PM -0800, Yinghai Lu wrote:
> 

> [PATCH] x86: introduce initial apicid
> 
> store initial_apicid from early identify. it is could be different from phys_proc_id later
> 
> also print it out in proc

Looks good to me now.

-Andi
