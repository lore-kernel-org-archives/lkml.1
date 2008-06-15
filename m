Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbYFOLZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbYFOLZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 07:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbYFOLZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 07:25:21 -0400
Received: from ic0245.upco.es ([130.206.70.245]:52125 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbYFOLZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 07:25:20 -0400
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel
	and VESA framebuffer
From: Romano Giannetti <romano@dea.icai.upcomillas.es>
To: Adrian Bunk <bunk@kernel.org>
Cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080615103934.GB21168@cs181133002.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A._5D.LJDVIB@albercik> <200806142359.36613.elendil@planet.nl>
	 <1213525379.15067.3.camel@localhost>
	 <20080615103934.GB21168@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 15 Jun 2008 13:25:17 +0200
Message-Id: <1213529117.7003.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-06-15 at 13:39 +0300, Adrian Bunk wrote:
> On Sun, Jun 15, 2008 at 12:22:59PM +0200, Romano Giannetti wrote:
> > 

> > > Yes. See also: http://lkml.org/lkml/2008/6/13/159
> > > -
> > 
> > It happens to me too. Do you see
> > http://bugzilla.kernel.org/show_bug.cgi?id=10892 ?
> 
> Does disabling CONFIG_X86_PAT also fix it for you?

Dunno. Do I need to recompile or there is some boot option to disable
it?

Rmano
-- 
Romano Giannetti                            Dep. de Electrónica y Automática
http://www.dea.icai.upcomillas.es/romano    Univ. Pontificia Comillas (MADRID)


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
