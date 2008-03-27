Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYC0KSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYC0KSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbYC0KSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:18:35 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:56520 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbYC0KSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:18:34 -0400
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
From: Romano Giannetti <romanol@upcomillas.es>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <2c0942db0803260930y741dfe81r114bd18b35e0bbe5@mail.gmail.com>
References: <200803220259.48534.rjw@sisk.pl>
	 <2c0942db0803260930y741dfe81r114bd18b35e0bbe5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 27 Mar 2008 11:18:32 +0100
Message-Id: <1206613112.26152.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2008-03-26 at 09:30 -0700, Ray Lee wrote: 
> 2008/3/21 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message contains a list of some regressions from 2.6.24 reported since
> >  2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> >  of.  If any of them have been fixed already, please let me know.
> [...]
> >  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10041
> >  Subject         : 2.6.25-rc1/2 regression: first-time login into gnome fails
> >  Submitter       : Romano Giannetti <romanol@upcomillas.es>
> >  Date            : 2008-02-18 11:56 (33 days old)
> >  References      : http://lkml.org/lkml/2008/2/18/145
> >  Handled-By      : Ray Lee <ray-lk@madrabbit.org>
> 
[...] 
> Though the original reporter hasn't replied, Christoph Hellwig hit the
> same issue and was able to confirm that installing the dbus-x11

Yes, I have answered in the bugzilla that installing dbus-x11
fixes/hides the problem for me:
http://bugzilla.kernel.org/show_bug.cgi?id=10041#c15


Should I have also posted it here? If so, sorry (but in this case, why
not set up auto-forwarding to l-k of the bugzilla entries related to the
Rafael regression list?)

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
