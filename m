Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXKENqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXKENqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 08:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXKENqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 08:46:36 -0500
Received: from ic0245.upco.es ([130.206.70.245]:59704 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbXKENqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 08:46:36 -0500
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071105132218.495f244e@poseidon.drzeus.cx>
References: <1193918202.8439.7.camel@rukbat>
	 <20071102182833.2c055446@poseidon.drzeus.cx>
	 <1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com>
	 <1194259886.6927.9.camel@localhost>
	 <20071105132218.495f244e@poseidon.drzeus.cx>
Content-Type: text/plain; charset=utf-8
Date: Mon, 05 Nov 2007 14:46:33 +0100
Message-Id: <1194270393.27789.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-05 at 13:22 +0100, Pierre Ossman wrote:
> On Mon, 05 Nov 2007 11:51:26 +0100
> > 
> 
> Ok, now this is a bit more telling. The filesystem is indeed corrupt
> somehow as it references sectors waaaay outside the device (at roughly
> 280 MB).

Yes. The problem is, when I firstly mounted it on 2.6.23 it worked
perfectly. If you think it's worthwhile, I can try to reboot in 2.6.23
and try to mount it again.

> Did you partition and format this card in the camera or in Linux?

In the camera. It happened both with a Kodak and a Panasonic Lumix. 

Romano 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
