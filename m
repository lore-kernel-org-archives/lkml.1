Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXBMSVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXBMSVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXBMSVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:21:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35723 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458AbXBMSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:21:19 -0500
Date: Tue, 13 Feb 2007 18:34:32 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Joel Soete <soete.joel@scarlet.be>, Tejun Heo <htejun@gmail.com>,
       Luming Yu <luming.yu@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
Message-ID: <20070213183432.6265afbb@localhost.localdomain>
In-Reply-To: <200702131915.12373.bzolnier@gmail.com>
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>
	<45D0D133.8070801@scarlet.be>
	<45D1F6E4.2080102@scarlet.be>
	<200702131915.12373.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you send me output of "hdparm --Istdout /dev/sdc" command?

Ditto - if this is one of the odd few quantums that need compile time
hacks in the old IDE its also one we need to do runtime handling for in
*both*.

