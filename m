Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbXJZF57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbXJZF57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXJZF5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:57:53 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:51842 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXJZF5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:57:52 -0400
Subject: Re: 2.6.24-rc1 fails with lockup and BUG:
From: Romano Giannetti <romanol@upcomillas.es>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1193242267.6914.6.camel@twins>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	 <1193232344.32208.0.camel@localhost> <20071024142759.GA13657@elte.hu>
	 <1193241191.14314.8.camel@localhost>  <20071024155521.GA16690@elte.hu>
	 <1193242267.6914.6.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 26 Oct 2007 07:57:49 +0200
Message-Id: <1193378269.17910.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-24 at 18:11 +0200, Peter Zijlstra wrote:
> On Wed, 2007-10-24 at 17:55 +0200, Ingo Molnar wrote:
> > 
> > hm, this lockdep warning caused lockdep to turn itself off - hence we 
> > wont get to the really interesting warnings. We'll try to come up with a 
> > solution for this.
> 
> Does this help?

I tried this, but although I have the D-state processes, I cannot see
any debug trace now. Results are at:

http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_3/

Can I try anything more? This is quite a show-stopper for me... and
before trying to bisect 11Mbyte of patches...

Romano 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
