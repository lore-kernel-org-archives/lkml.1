Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZEQK1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZEQK1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbZEQK0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:26:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489AbZEQK0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:26:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [Bug #13245] possible circular locking dependency detected
Date: Sun, 17 May 2009 12:26:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.nFB.5YzDKB@chimera> <d82e647a0905162022k7be627f1s933a84640562f749@mail.gmail.com>
In-Reply-To: <d82e647a0905162022k7be627f1s933a84640562f749@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171226.57915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Ming Lei wrote:
> I also can reproduce it on 2.6.30-rc5-next-20090515.
> 
> 2009/5/17 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13245
> > Subject         : possible circular locking dependency detected
> > Submitter       : Miles Lane <miles.lane@gmail.com>
> > Date            : 2009-05-04 16:56 (13 days old)

Thanks for the update.

Rafael
