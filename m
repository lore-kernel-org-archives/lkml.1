Return-Path: <linux-kernel-owner+w=401wt.eu-S1763736AbXH0Woz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763736AbXH0Woz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758335AbXH0Woq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:44:46 -0400
Received: from postin.uv.es ([147.156.1.90]:38808 "EHLO postin.uv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708AbXH0Woq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:44:46 -0400
From: =?iso-8859-15?q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: Problems with IDE on linux 2.6.22.X
Date: Tue, 28 Aug 2007 00:44:34 +0000
User-Agent: KMail/1.9.5
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
References: <200708212149.12912.jopan@alumni.uv.es> <20070822162312.GG9412@csclub.uwaterloo.ca> <46CC6A2F.5000406@gmail.com>
In-Reply-To: <46CC6A2F.5000406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708280044.34475.jopan@alumni.uv.es>
X-RelayDelay-Mem: Whitelisted relay cuervo.ci.uv.es [147.156.1.157]. Not delayed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Miércoles, 22 de Agosto de 2007 16:54, Rene Herman escribió:
> José: do you have SCSI CD-ROM support compiled in? What are the ATA/SCSI
> related messages in the output of "dmesg" when you compile with the
> CONFIG_ATA_PIIX driver, SCSI disk and SCSI CD-ROM support (and nothing from
> the old IDE menu)?
>
> Rene.

Hi again. I'm very sorry for the delay. I was on a travel since wednesday 22.

Okay Rene, I activated SCSI CD-ROM support in kernel config and now all works 
again. It's strange, because I never used this option to get my DVD device 
on.

Well, sorry for the inconvenience. Thanks for your help.
