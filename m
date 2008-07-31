Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYGaXQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYGaXQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 19:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYGaXP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 19:15:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:7943 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYGaXP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 19:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iGTHsJFKT7KYCWNo78i1rc5KLLoyCYgiemykvBEQ5ywBb6c8/8DloFtaKM1tK5dk24
         V9ZGXoI7gPIUir+MHx3Xr5ZY7cRnKtSUA1kjkmJvtBhqtK73m9/JIiMV6gV3Hp6+DCfH
         mouBUw/HzxfzJZYhqB+SRDhRQw9RGMl31exa4=
Message-ID: <12c511ca0807311615w15c10e15udeefbfeb0b205a@mail.gmail.com>
Date: Thu, 31 Jul 2008 16:15:57 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Sam Ravnborg" <sam@ravnborg.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, "Jeff Dike" <jdike@addtoit.com>
In-Reply-To: <20080730193921.GA4475@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730124952.GA23413@uranus.ravnborg.org>
	 <20080730180411.GA7896@elte.hu>
	 <20080730184700.GA29710@uranus.ravnborg.org>
	 <20080730191907.GD26389@elte.hu>
	 <20080730193921.GA4475@uranus.ravnborg.org>
X-Google-Sender-Auth: cd0f67b37c9492f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So is there a better or worse time to move the include files?

At the end of a merge window would seem to be
the least disruptive time.  So we can either hit this
now, or wait until the next merge.

-Tony

[Just did the ia64 move locally with no apparent problems, should I
commit and send a "please pull"?]
