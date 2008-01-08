Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYAHKlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYAHKlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYAHKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:41:41 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:23317 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbYAHKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FYsAZIBT+7DnRY4zU2f9sTEY47pLnLs16+ZbFpOFpYHjqCQkFMrsd5VG3G9zTcOUOYcPO17j8GDcKCXDL8q+9UMr4hgPHB8GTtbWDdpCPnomikaybic+kB2w4Z/owyqPjmi6eEdijHnP+fH/Gef1CL5acZt4G4nrrq1+07vOO6M=
Message-ID: <4d8e3fd30801080241i30036aex8947cb4f8178a5a4@mail.gmail.com>
Date: Tue, 8 Jan 2008 11:41:37 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/5] Codying style fixes in ./arch/x86/ia32
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, trivial@kernel.org
In-Reply-To: <20080108102826.GD6906@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4d8e3fd30801070335n79d910dbt48d0ef0f3597c670@mail.gmail.com>
	 <20080108102003.GC6906@elte.hu>
	 <4d8e3fd30801080224ra6332c6m6b61b0db45dd72ca@mail.gmail.com>
	 <20080108102826.GD6906@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 11:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>
> > > i fixed this up, but the other patches in your queue are corrupted
> > > too, they have linewraps and tabs->spaces problems as well.
> >
> > :-/ Sorry about that, I fwed the patch queue with gmail.
>
> no problem.
>
> > >   Subject: x86: coding style fixes in arch/x86/ia32/audit.c
> > >
> > > (also please keep them lower case)
> >
> > OK, will do that when I'll back home.
> >
> > And I'll send the patch queue using a proper MUA :-)
>
> btw., there's "quilt mail" or "git-send-email" that can send patchsets
> as well, it's much easier than sending patches manually.

I'll give git-send-email a try, since I started using git rebase -i I
didn't feel the need
of quilt/stgit but I should learn how to use these tools as well :-)

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
