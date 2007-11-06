Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbXKFWRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbXKFWRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbXKFWRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:17:44 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:54193 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbXKFWRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:17:43 -0500
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romano@dea.icai.upcomillas.es>
To: Willy Tarreau <w@1wt.eu>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1194385693.12938.5.camel@rukbat>
References: <1193918202.8439.7.camel@rukbat> 
	<20071102182833.2c055446@poseidon.drzeus.cx> 
	<1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com> 
	<1194259886.6927.9.camel@localhost> 
	<20071105132218.495f244e@poseidon.drzeus.cx> 
	<1194270393.27789.2.camel@localhost> 
	<20071105162633.09e54290@poseidon.drzeus.cx> 
	<1194343121.6953.6.camel@rukbat>  <20071106195148.GD1045@1wt.eu> 
	<1194385693.12938.5.camel@rukbat>
Content-Type: text/plain;
	charset=utf-8
Date: Tue, 06 Nov 2007 23:17:39 +0100
Message-Id: <1194387459.5205.2.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 22:48 +0100, Romano Giannetti wrote:

> I do really suspect a software bug.
>

Well, I started bisecting it. It will be a long shot, I suspect...

	Romano

BTW: I noticed that if I change EXTRAVERSION, doing a make rebuild
almost all the kernel. Is it normal? And it seems to me that the same
thing happens if a make oldconfig results in a changed .config...




--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

