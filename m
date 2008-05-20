Return-Path: <linux-kernel-owner+w=401wt.eu-S1765904AbYETKHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765904AbYETKHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbYETKEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:04:33 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:49179 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbYETKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:04:32 -0400
Subject: Re: 2.6.26-rc2 hosed X?
From: Romano Giannetti <romanol@upcomillas.es>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080520081617.GA14141@gamma.logic.tuwien.ac.at>
References: <20080513103828.GA8288@gamma.logic.tuwien.ac.at>
	 <1211269474.8773.10.camel@localhost>
	 <20080520081617.GA14141@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 20 May 2008 11:54:42 +0200
Message-Id: <1211277282.10197.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 10:16 +0200, Norbert Preining wrote:
> On Di, 20 Mai 2008, Romano Giannetti wrote:

> > 
> > Maybe related to: http://bugzilla.kernel.org/show_bug.cgi?id=10620 ?
> 
> I had the very same problems like you and I had to apply two patches:
> (see http://bugzilla.kernel.org/show_bug.cgi?id=10709)
> 
> The one is included in -rc3, that was solved by applying 
> 	http://lkml.org/lkml/2008/5/13/188
> 
> the former was solved by using the vblank reverse patch given in the
> above bug, or directly here:
> 	http://marc.info/?l=linux-kernel&m=121074889124387&w=4
> 

OK: fixed in v2.6.26-rc3-119-g8033c6e, which includes the above
patches. 

Thanks to all. 

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
