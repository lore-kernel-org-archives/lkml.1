Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbYFKHig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbYFKHig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYFKHi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:38:28 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:59824 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYFKHi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:38:27 -0400
Subject: Re: [regression?] Sometime (often) X come out blank (black screen)
	on cold boot - Intel chipset
From: Romano Giannetti <romanol@upcomillas.es>
To: Justin Madru <jdm64@gawab.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       lkml <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Sa=EFvann?= Carignan <oxmosys@gmail.com>
In-Reply-To: <484F5582.5000805@gawab.com>
References: <1213101501.21041.9.camel@pern>  <484F5582.5000805@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 11 Jun 2008 09:38:25 +0200
Message-Id: <1213169905.9453.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-10 at 21:33 -0700, Justin Madru wrote:
> 
> Can you confirm, so Rafael Wysocki can mark your report 
> http://bugzilla.kernel.org/show_bug.cgi?id=10892 as a dup of 
> http://bugzilla.kernel.org/show_bug.cgi?id=10235.
> 

Dunno. It happens to me ONLY on cold boot, and never otherwise. I had a
similar bug after resume, but it was fixed by the vblank revert patch.

> Does disabling the boot splash fix the problem? You could also try 
> disabling gdm and starting X manually. When I disable usplash it
> fixes 
> the problem.

Will try. But it's quite rare for me, so triggering it is not so easy.
For the same reason, a bisect is difficult...

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
