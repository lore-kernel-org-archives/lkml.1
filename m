Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbYHaLw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbYHaLw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 07:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbYHaLwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 07:52:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60196 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbYHaLwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 07:52:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [Bug #11464] BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
Date: Sun, 31 Aug 2008 13:56:09 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Backlund" <tmb@mandriva.org>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.HBD.mhbuIB@albercik> <200808302327.09332.herton@mandriva.com.br>
In-Reply-To: <200808302327.09332.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311356.10628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 31 of August 2008, Herton Ronaldo Krzesinski wrote:
> Em Saturday 30 August 2008 16:50:30 Rafael J. Wysocki escreveu:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11464
> > Subject		: BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
> > Submitter	: Thomas Backlund <tmb@mandriva.org>
> > Date		: 2008-08-30 12:46 (1 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122010171130384&w=4
> 
> Hi, you can close/remove this as it's not a regression on vanilla 2.6.27-rc5, 
> it only happens if you use tomoyo linux + apparmor patches that is not on 
> mainline, sorry for any trouble this may have caused.

Thanks, closed.

Rafael
