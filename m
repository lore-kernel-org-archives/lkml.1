Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbYBAR17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbYBAR17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbYBAR1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:27:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:27582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbYBAR1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=a6PO5A47dp6V4fNyK5+0YR6Htq1avsK6nHuo9NZFeZmImpd8sNRXS/1lj+TT+SXdotnvPZg2TbHRtAlSww8wfciOw0etMe5BrtlTWyFFNCOGSPcp52AbmMVosbIYaU1o47lecCjKFMv9sTYiscwGkRiUsvpxBFPivGn4WgInET0=
Date: Fri, 1 Feb 2008 20:27:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup - eliminate numbers in LDT allocation code
Message-ID: <20080201172729.GC6730@cvg>
References: <20080201171422.GA6730@cvg> <20080201171826.GA13738@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201171826.GA13738@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Feb 01, 2008 at 06:18:26PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > This patch eliminates numbers in LDT allocation code trying to make it 
| > clear to understand from where these numbers are go
| 
| thanks, applied.
| 
| > I hope nobody shoot me ;)
| 
| nope, magic constants are bad in general.
| 
| 	Ingo
|

Thanks Ingo, and really thanks to Andi for his
explanation on this case.

		- Cyrill -
