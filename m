Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYEGMkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYEGMkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYEGMjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:39:42 -0400
Received: from ic0245.upco.es ([130.206.70.245]:59428 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643AbYEGMja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:39:30 -0400
Subject: Re: [RFC] Kernel naming convention in the merge phase
From: Romano Giannetti <romanol@upcomillas.es>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oliver Hartkopp <oliver@hartkopp.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <481A06C0.6070500@zytor.com>
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>
	 <48198873.7030503@hartkopp.net>  <481A06C0.6070500@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 07 May 2008 14:39:24 +0200
Message-Id: <1210163964.14371.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-01 at 11:06 -0700, H. Peter Anvin wrote:

> Most of the robots don't have access to git.
> 
> > For me a 2.6.25-gitX looks like a snapshot that leads to a 2.6.25.1 and 
> > _not_ to a 2.6.26-rc1.
> 
> Tough.  It's a naming convention quite old (we had -bk before -git, too.)

What about a -rc0 as the first commit after a release? Will help a lot
automatic installing scripts...

Romano 
 
-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
