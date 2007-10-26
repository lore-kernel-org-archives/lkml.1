Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbXJZF77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbXJZF77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXJZF7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:59:52 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:51849 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXJZF7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:59:51 -0400
Subject: Re: 2.6.24-rc1 fails with lockup and BUG:
From: Romano Giannetti <romanol@upcomillas.es>
To: Joseph Fannin <jfannin@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071024164445.GA6452@nineveh.local>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	 <1193232344.32208.0.camel@localhost>  <20071024164445.GA6452@nineveh.local>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 26 Oct 2007 07:59:49 +0200
Message-Id: <1193378389.17910.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-24 at 12:44 -0400, Joseph Fannin wrote:
> On Wed, Oct 24, 2007 at 03:25:44PM +0200, Romano Giannetti wrote:
> >
> >
> Denis V. Lunev wrote a patch for the NetworkManager thing a day or two
> ago (which DaveM has queued).
> 
> Since netlink is involved in the traces you sent, this might do something
> for the other too.

This *do* fix the "network manager needs to be restarted at boot" part
of the problem, but leave as is the worst one (the failed suspend to ram
and following bugs). 

	Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
