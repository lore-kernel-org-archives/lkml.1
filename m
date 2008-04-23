Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYDWIUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYDWIUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYDWITy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:19:54 -0400
Received: from ic0245.upco.es ([130.206.70.245]:54157 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbYDWITu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:19:50 -0400
Subject: Re: x86: 4kstacks default
From: Romano Giannetti <romanol@upcomillas.es>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: david@lang.hm, Denys Vlasenko <vda.linux@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200804230141.09523.dhazelton@enter.net>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <200804230121.11004.dhazelton@enter.net>
	 <alpine.DEB.1.10.0804222222490.23325@asgard>
	 <200804230141.09523.dhazelton@enter.net>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 23 Apr 2008 09:46:27 +0200
Message-Id: <1208936787.13905.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[Trimmed, I hope I got the authors right...]

On Wed, 2008-04-23 at 01:41 -0400, Daniel Hazelton wrote:
> > On Wed, 23 Apr 2008, Daniel Hazelton wrote:
> > > On Wednesday 23 April 2008 01:03:11 Denys Vlasenko wrote:
> > >> On Tuesday 22 April 2008 20:20, Romano Giannetti wrote:

> > >>> I know all the trouble ndiswrapper signify. But I see also that people
> > >>> around me with a laptop and linux use more ndiswrapper than a real
> > >>> driver, so... be gentle with it.
> > >>
> > >> Nobody knows how much potential development is not done because
> > >> "you can make your wifi work with ndiswrapper".
> > >

> And how much better would it be if the drivers were native linux code and were 
> fully supportable because of that?

I understand your position, but let me give my example. I have this
laptop that is one year old. I'm helping in all what I can to the
development of ath5k --- IOW, offering testing, I am not an expert on
this. 

But the mere fact that ndiswrapper exists enabled me to use this laptop
on a daily basis, and so I could test new kernel (and if you look at the
logs you'll see I had at least helped to fix a nasty MMC bug, and to
make sound work in this laptop) and help in other areas, like
suspend/resume testing and bug chasing. 

There is not only wireless development. Without ndiswrapper, I wouldn't
have been in any position to help other areas. I would have had a
crippled laptop[1], a much higher Vista uptime (which now is 0), and a
far bitter Linux experience.  

And this is the point of view of someone that is using Linux since
0.99pl9, so I have quite a bit of experience. 99% of normal users would
simply say "don't work"[2].

		Romano

[1] yes, there's a madwifi version locked to a specific kernel that
works with my card. But I do not think that this would be so much
different. 

[2] a nice page with "_this_ laptop will fully work with linux" would be
nice. Linux on laptop or similar is too complex to be a real help when
you have to buy a laptop in 2 days. 


-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
