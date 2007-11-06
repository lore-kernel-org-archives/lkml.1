Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXKFVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXKFVCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbXKFVC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:02:29 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:53948 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXKFVC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:02:28 -0500
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
From: Romano Giannetti <romanol@upcomillas.es>
To: Willy Tarreau <w@1wt.eu>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071106195148.GD1045@1wt.eu>
References: <1193918202.8439.7.camel@rukbat>
	 <20071102182833.2c055446@poseidon.drzeus.cx>
	 <1194168583.10245.15.camel@rukbat> <ada8x5ec7oh.fsf@cisco.com>
	 <1194259886.6927.9.camel@localhost>
	 <20071105132218.495f244e@poseidon.drzeus.cx>
	 <1194270393.27789.2.camel@localhost>
	 <20071105162633.09e54290@poseidon.drzeus.cx>
	 <1194343121.6953.6.camel@rukbat>  <20071106195148.GD1045@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 06 Nov 2007 22:02:24 +0100
Message-Id: <1194382944.12938.1.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-06 at 20:51 +0100, Willy Tarreau wrote:

> It looks like a hardware problem to me. Maybe one version is more
> optimized and puts more stress on the device ? I remember having
> had comparable problems in the past with a CF connected to a
> home-made IDE adapter on which the +5V wire had been cut. The CF
> drained its power from the IDE signals and it would most always
> work correctly, except when reading large files. Writing to it
> finally killed it.  
> 

Obviously I cannot be sure, but I tested it a lot under 2.6.23 and Vista
and never had a single problem. If it's an HW problem, for sure Linux
2.6.24 has the capacity to trigger it at the first try...

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
