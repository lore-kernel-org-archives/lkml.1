Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYB1J0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYB1J0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYB1J0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:26:43 -0500
Received: from ic0245.upco.es ([130.206.70.245]:45821 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbYB1J0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:26:41 -0500
Subject: Re: Intel 945GM: 2.6.25-rc3 report (with a possible regression)
From: Romano Giannetti <romanol@upcomillas.es>
To: Frans Pop <elendil@planet.nl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
In-Reply-To: <E1JULSV-0001qy-7N@faramir.fjphome.nl>
References: <1204056556.7745.22.camel@localhost>
	 <1204056556.7745.22.camel@localhost> <47C4AEDC.80600@s5r6.in-berlin.de>
	 <E1JULSV-0001qy-7N@faramir.fjphome.nl>
Content-Type: text/plain; charset=ISO-8859-15
Date: Thu, 28 Feb 2008 10:26:34 +0100
Message-Id: <1204190794.16668.4.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2008-02-27 at 13:32 +0100, Frans Pop wrote:

> This sounds like that could be a bug I filed recently and which was solved
> in 2.2.1: http://bugs.freedesktop.org/show_bug.cgi?id=14481.

Yes, it seems the same. I will try as soon as I came around to a way to
do it. 

Could this account to the LCD/CRT switching problem to? This is the most
critical to me, since I can't use the laptop to give presentations. I
double checked if the key combination is managed in user space, but it
seems that it did not send ACPI events nor keypresses, so I suspect that
it is a kernel matter (or BIOS, maybe). 

Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
