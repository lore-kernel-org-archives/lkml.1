Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZHTVcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZHTVcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZHTVcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:32:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39516 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbZHTVcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:32:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [Bug #13946] x86 MCE malfunction on Thinkpad T42p
Date: Thu, 20 Aug 2009 23:32:57 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.Rj.9NIjKB@chimera> <20090820202226.GA4444@sig21.net>
In-Reply-To: <20090820202226.GA4444@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908202332.57566.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Johannes Stezenbach wrote:
> On Wed, Aug 19, 2009 at 10:26:57PM +0200, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13946
> > Subject		: x86 MCE malfunction on Thinkpad T42p
> > Submitter	: Johannes Stezenbach <js@sig21.net>
> > Date		: 2009-08-07 17:09 (13 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124966500232399&w=4
> > Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/37908/
> 
> This is fixed in v2.6.31-rc6-223-g6c30c53 by
> commit c7f6fa44115d401e89db730f357629d39f8e4ba6
> "x86, mce: don't log boot MCEs on Pentium M (model == 13) CPUs".

Thanks, closed.

Rafael
