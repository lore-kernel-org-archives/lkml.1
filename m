Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYFMKgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYFMKgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 06:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYFMKgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 06:36:36 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:39967 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYFMKgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 06:36:35 -0400
Subject: Re: [regression?] Sometime (often) X come out blank (black screen)
	on cold boot - Intel chipset
From: Romano Giannetti <romanol@upcomillas.es>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Justin Madru <jdm64@gawab.com>
In-Reply-To: <200806110912.59819.jbarnes@virtuousgeek.org>
References: <1213101501.21041.9.camel@pern>
	 <200806101106.23899.jbarnes@virtuousgeek.org>
	 <1213160635.9453.15.camel@localhost>
	 <200806110912.59819.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-15
Date: Fri, 13 Jun 2008 12:36:32 +0200
Message-Id: <1213353392.7505.4.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-11 at 09:12 -0700, Jesse Barnes wrote:
> Check out http://www.intellinuxgraphics.org/ for instructions on building the 
> driver.  You may also want to check out Freedesktop bug 15602 which Justin 
> filed upstream (https://bugs.freedesktop.org/show_bug.cgi?id=15602).

I will try to look at it --- RL entered in the game this week and
overwhelmed me a bit. 

Maybe it's related, maybe not, but as an hint I can say that the X
screen also used to go black everytime I switch from AC supply to
battery. This morning I did a ubuntu x-intel-driver update, and it seems
that now I can't reproduce that glitch anymore. 

Romano  
-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
