Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbZANK70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbZANK70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbZANK7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:59:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbZANK7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:59:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [Bug #12420] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Date: Wed, 14 Jan 2009 11:58:52 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: Alexey Rempel <fishor@gmx.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <496D95BA.4070304@gmx.net> <200901140840.39202.borntraeger@de.ibm.com>
In-Reply-To: <200901140840.39202.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141158.53554.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009, Christian Borntraeger wrote:
> Am Mittwoch 14 Januar 2009 schrieb Alexey Rempel:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12420
> > > Subject		: WARNING: at drivers/ata/libata-sff.c:1017 
> ata_sff_hsm_move+0x45e/0x750()
> > > Submitter	: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Date		: 2009-01-09 12:34 (3 days old)
> > > First-Bad-Commit: 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=871af1210f13966ab911ed2166e4ab2ce775b99d
> > > References	: http://marc.info/?l=linux-kernel&m=123150457832109&w=4
> 
> 
> > This warning was disabled in latest git.
> 
> Yes. After the discussion had a conclusion, I decided to to send a patch 
> myself and Jeff sent it to Linus.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a0f79f7ad3e52b908786462cf5446ebe20fe14fa

Thanks, closed.

Rafael
