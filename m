Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYDVSVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYDVSVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYDVSU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:20:58 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:46980 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYDVSU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:20:57 -0400
Subject: Re: x86: 4kstacks default
From: Romano Giannetti <romanol@upcomillas.es>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200804201144.33308.dhazelton@enter.net>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080420104444.GI1595@cs181133002.pp.htv.fi>
	 <87y778aezh.fsf@basil.nowhere.org> <200804201144.33308.dhazelton@enter.net>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 22 Apr 2008 20:20:54 +0200
Message-Id: <1208888454.10279.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2008-04-20 at 11:44 -0400, Daniel Hazelton wrote:
> Since the second-most-common reason for stack overages is ndiswrapper... Well, 
> with there being so much more hardware now supported directly by the linux 
> kernel... 

How would I like you being right... Atheros AR5008, AR5414 PHY, "not yet
here". It's almost one year now since I bought this laptop, and till now
it's the cable or ndiswrapper. But yes, it's going better. For my first
wifi laptop I waited two and a half years, now it seems that in a bit
more than one there will be an open source driver...

I know all the trouble ndiswrapper signify. But I see also that people
around me with a laptop and linux use more ndiswrapper than a real
driver, so... be gentle with it. 

Thanks,
	Romano 	

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
