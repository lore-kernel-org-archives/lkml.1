Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZEQK0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZEQK0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbZEQK0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:26:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46339 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbZEQK0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:26:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [Bug #13118] iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
Date: Sun, 17 May 2009 12:26:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@vyatta.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.geC.vZzDKB@chimera> <b6a2187b0905162306u17c07753w8af53b6ed807cf1d@mail.gmail.com>
In-Reply-To: <b6a2187b0905162306u17c07753w8af53b6ed807cf1d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171226.34104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Jeff Chua wrote:
> On Sun, May 17, 2009 at 3:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13118
> > Subject         : iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
> > Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> > Date            : 2009-04-10 16:05 (37 days old)
> > References      : http://lkml.org/lkml/2009/4/10/111
> >                  http://lkml.org/lkml/2009/4/25/83
> > Handled-By      : Eric Dumazet <dada1@cosmosbay.com>
> 
> Fixed as of Apr 28.
> 
> commit 942e4a2bd680c606af0211e64eb216be2e19bf61
> Author: Stephen Hemminger <shemminger@vyatta.com>
> Date:   Tue Apr 28 22:36:33 2009 -0700
> 
>     netfilter: revised locking for x_tables

Thanks, closed.

Best,
Rafael
