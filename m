Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYDWMPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYDWMPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYDWMPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:15:05 -0400
Received: from ic0245.upco.es ([130.206.70.245]:59812 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYDWMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:15:04 -0400
Subject: Re: x86: 4kstacks default
From: Romano Giannetti <romanol@upcomillas.es>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Daniel Hazelton <dhazelton@enter.net>, david@lang.hm,
       Denys Vlasenko <vda.linux@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <480F1C60.4030305@s5r6.in-berlin.de>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <200804230121.11004.dhazelton@enter.net>
	 <alpine.DEB.1.10.0804222222490.23325@asgard>
	 <200804230141.09523.dhazelton@enter.net>
	 <1208936787.13905.14.camel@localhost>  <480F1C60.4030305@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 23 Apr 2008 14:15:01 +0200
Message-Id: <1208952901.11823.13.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2008-04-23 at 13:24 +0200, Stefan Richter wrote:
> Romano Giannetti wrote:
> [stack size requirements -> ndiswrapper -> hardware support status -> ?]
> > a nice page with "_this_ laptop will fully work with linux" would be
> > nice. Linux on laptop or similar is too complex to be a real help when
> > you have to buy a laptop in 2 days. 
> 
> If sites like tuxmobil.org, hardware4linux.info, and the hardware
> compatibility databases of Linux distributors don't work for you, then
> just ask the notebook vendors directly.

Unfortunately, it is quite a complex thing to check. Mind you, I've
bought this laptop after looking all over there, but:

- tuxmobil & Co are very user-driven, and you have to swim among tenth
of "similar" computer;

- it's not so easy to know what exactly is bundled with a laptop[1];

- vendor say "works" (and often is listed as works in the aforementioned
sites too) independently if it works with an open source driver or not.
As an example, all the nvidia-based graphics are marked "works".

Romano 

[1] In my case, I selected this toshiba over for example a HP or an Acer
because it had "atheros wifi" (but guess that the PHY version is too new
to be supported...), "intel hda sound" (but guess that the specific
codec didn't work at all, and continues to have a lot of problems), 
"intel graphics" (and that at least was a good decision!). 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
