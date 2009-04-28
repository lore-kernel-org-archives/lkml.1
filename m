Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbZD1Vtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbZD1Vtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZD1Vtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:49:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbZD1Vto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:49:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jos van der Ende <seraph@xs4all.nl>
Subject: Re: [Bug #12947] r128: system hangs when X is started with DRI enabled
Date: Tue, 28 Apr 2009 23:49:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "DRI" <dri-devel@lists.sourceforge.net>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera> <200904261943.45126.rjw@sisk.pl> <20090427201229.3491928a.seraph@xs4all.nl>
In-Reply-To: <20090427201229.3491928a.seraph@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904282349.02147.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Jos van der Ende wrote:
> On Sun, 26 Apr 2009 19:43:44 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday 26 April 2009, Angel wrote:
> > > On Sun, 26 Apr 2009 11:46:26 +0200 (CEST)
> > > 
> > > I've tested with kernel 2.6.29.1. The problem still persists. While everything works fine with 2.6.28 or lower, starting X (both 1.3 and 1.5) with DRI enabled on a 2.6.29 kernel results in a garbled screen and unresponsive keyboard.
> > 
> > Thanks for the update.
> > 
> > Can you also test 2.6.30-rc3, please?
> 
> Sure. Still broken in exactly the same way. (Garbled screen, non-working keyboard. System can still be ssh-ed into.)

Thanks!

Best,
Rafael
