Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYCEPii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYCEPii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYCEPi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:38:29 -0500
Received: from antispam.upcomillas.es ([130.206.70.245]:58944 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbYCEPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:38:28 -0500
Subject: Re: Google's Summer of Code?
From: Romano Giannetti <romanol@upcomillas.es>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Cc: Rik van Riel <riel@redhat.com>, Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <47CEA6B1.3080803@cateee.net>
References: <84144f020803041045i70bbb05l6983bd14c5bcc91a@mail.gmail.com>
	 <alpine.LFD.1.00.0803041127290.12253@woody.linux-foundation.org>
	 <84144f020803041155k222c13ecu13c8c9534ced87e5@mail.gmail.com>
	 <f19298770803041205i21a0c6d2mdf712b52cb00cfd5@mail.gmail.com>
	 <20080304152303.2a041814@cuia.boston.redhat.com>
	 <47CEA6B1.3080803@cateee.net>
Content-Type: text/plain; charset=ISO-8859-15
Date: Wed, 05 Mar 2008 16:38:25 +0100
Message-Id: <1204731505.9292.7.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-05 at 14:57 +0100, Giacomo A. Catenazzi wrote:
> - add support to menuconfig, to show what you should enable (not
> really an automagical configuration, but more an helper which
> know better(?) your hardware).

Yes, this would be a tool worth Infinite Distinction for a lot of Linux
users. Say I have a new laptop and I want to configure the kernel build
based on a) the (probably similar to allmodconfig) distribution .config,
and b) the set of loaded modules. It should be possible to dig into
Kconfig files and output a first-shot .config, which will save to
potential testers of new kernels hours of compilation and/or trimming 
down `grep CONFIG .config | wc -l` (2267) configuration options.

Thanks for proposing the idea.

Romano 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
