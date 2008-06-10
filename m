Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYFJMW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYFJMW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYFJMWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:22:49 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:51733 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYFJMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:22:48 -0400
Subject: Re: ALC883 recording troubles...
From: Romano Giannetti <romanol@upcomillas.es>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Tue, 10 Jun 2008 14:22:45 +0200
Message-Id: <1213100565.21041.3.camel@pern>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-09 at 20:59 +0100, Daniel J Blueman wrote:
> 
> I'm experiencing DC offset with the microphone on 2.6.24 (Ubuntu 8.04
> LTS x86-64). I can see on Audacity that the DC offset that varies with
> the recording capture level. 

Probably the same as
https://bugtrack.alsa-project.org/alsa-bug/view.php?id=3824

I thought I was the only one seeing that, given the answers I got... 

> What's the routine to debug this? Would it help to install windows,
> dump the register space and compare?

I am available to help, too. My card works quite well, modulo the mic
problem and a lower output than in Vista, and I'd love to see it solved.

Romano 

-- 
Sorry for the disclaimer --- ¡I cannot stop it!



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
