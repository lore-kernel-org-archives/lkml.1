Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYJJM1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYJJM1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYJJM0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:26:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:9875 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYJJM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oM6Utk7kGUXmTHxYcTLqCTF0TjO3yT9V1/SvTbnH0uxS+guUPphimMesLXkDf+0RTu
         10dbNabeOrAo9Np9lQ//LMabnmmbik7ua881lv3D+5hAJnSCX22VCW+cpnn9cew+Hxdx
         rCR4Fseh1tNb56cu9+nUbUDO8aL5P6mPMSmP0=
Date: Fri, 10 Oct 2008 16:26:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Message-ID: <20081010122639.GA7328@localhost>
References: <20081010002203.GA23238@linux-os.sc.intel.com> <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com> <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com> <20081010090100.GC319@elte.hu> <aa79d98a0810100416q72ec10d5q7d841e02dc4d4f81@mail.gmail.com> <alpine.LFD.1.10.0810101221580.19747@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810101221580.19747@ftp.linux-mips.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Fri, Oct 10, 2008 at 12:24:35PM +0100]
| On Fri, 10 Oct 2008, Cyrill Gorcunov wrote:
| 
| > Btw I don't remember but hope it was not me who made this typo --
| 
|  What would be the difference so that you hope it wasn't you?  All the 
| people make mistakes, this one has been caught and that's what really 
| matters.
| 
|   Maciej
| 

Well this CONFG typo just remind me one I brought once :)

		- Cyrill -
