Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbXIDJ43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbXIDJ43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 05:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXIDJ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 05:56:22 -0400
Received: from ic0245.upco.es ([130.206.70.245]:47223 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbXIDJ4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 05:56:21 -0400
X-Greylist: delayed 1422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2007 05:56:20 EDT
Subject: Re: Hang in 2.6.23-rc5
From: Romano Giannetti <romanol@upcomillas.es>
To: Patrick Mau <mau@oscar.ping.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070903063904.GA1935@oscar.prima.de>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com> 
	<6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com> 
	<5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com> 
	<20070902232939.f2c8acbb.francois.cami@free.fr> 
	<20070902214631.GA1892@martell.zuzino.mipt.ru> 
	<alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in> 
	<20070903063904.GA1935@oscar.prima.de>
Content-Type: text/plain;
	charset=utf-8
Date: Tue, 04 Sep 2007 11:32:24 +0200
Message-Id: <1188898344.8538.11.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 08:39 +0200, Patrick Mau wrote:

> In addition I totally agree with Satyam's comment above: either
> anybody is testing rc's these days, or people simply stopped reporting.
>

Hi,

	I had network-related locks with rc5, but refrained to post here
because I am using ndiswrapper... I was waiting to go back home and try
to reproduce without it, by connecting the laptop to a wired network. I
will try the patch proposed.

Thanks,
	Romano. 





--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

