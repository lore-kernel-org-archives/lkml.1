Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYFKFzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYFKFzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYFKFzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:55:03 -0400
Received: from ic0245.upco.es ([130.206.70.245]:58373 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYFKFzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:55:01 -0400
Subject: Re: [regression?] Sometime (often) X come out blank (black screen)
	on cold boot - Intel chipset
From: Romano Giannetti <romanol@upcomillas.es>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Justin Madru <jdm64@gawab.com>
In-Reply-To: <200806101106.23899.jbarnes@virtuousgeek.org>
References: <1213101501.21041.9.camel@pern>
	 <200806101106.23899.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 11 Jun 2008 07:03:55 +0200
Message-Id: <1213160635.9453.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-10 at 11:06 -0700, Jesse Barnes wrote:
> On Tuesday, June 10, 2008 5:38 am Romano Giannetti wrote:

> This sounds like a DUP; I remember Justin Madru had a similar issue (with 
> Ubuntu & gdm even iirc).
> 
> Is there any way you could run the latest git bits of the Intel X driver?  
> I've added some debugging that could catch at least one of the common reasons 
> why the display would blank like that...

Yes, I think I can. Please give me instructions... I have a git
repository tracking Linus' one. 

BTW, maybe I'm on dope, but thinking hard, it seems to me that the blank
screen happens nly when I cold reboot after a crash forced me to
poweroff abruptly the laptop. Last time happened after a battery runoff.
It's that possible?

Moreover, I see a lot of flashing on shutdown (I'm sure I've seen a
report like that, but I am unable to dig it out now)...

Thanks,
	Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
