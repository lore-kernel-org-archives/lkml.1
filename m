Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYF2R3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYF2R3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 13:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYF2R3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 13:29:45 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:37315 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbYF2R3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:29:44 -0400
Subject: Re: ALC883 recording troubles...
From: Romano Giannetti <romano@dea.icai.upcomillas.es>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806280624iec3a67rf25789e98f81521@mail.gmail.com>
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
	 <6278d2220806280529n70c6233dk1c5768df5d52acf@mail.gmail.com>
	 <19f34abd0806280539g4961392evb469d7c106c198c9@mail.gmail.com>
	 <6278d2220806280624iec3a67rf25789e98f81521@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 29 Jun 2008 19:29:41 +0200
Message-Id: <1214760581.6998.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-28 at 14:24 +0100, Daniel J Blueman wrote:
> # ./hda-verb /dev/snd/hwC0D0 0x0e SET_AMP_GAIN_MUTE 0x7080
> # ./hda-verb /dev/snd/hwC0D0 0x0f SET_AMP_GAIN_MUTE 0x7080
> # ./hda-verb /dev/snd/hwC0D0 0x0f SET_AMP_GAIN_MUTE 0x7180
> # ./hda-verb /dev/snd/hwC0D0 0x10 SET_AMP_GAIN_MUTE 0x7080
> # ./hda-verb /dev/snd/hwC0D0 0x10 SET_AMP_GAIN_MUTE 0x7180
> # ./hda-verb /dev/snd/hwC0D0 0x10 SET_AMP_GAIN_MUTE 0x7280
> # ./hda-verb /dev/snd/hwC0D0 0x18 SET_AMP_GAIN_MUTE 0x7080
> # ./hda-verb /dev/snd/hwC0D0 0x19 SET_AMP_GAIN_MUTE 0x7080
> # ./hda-verb /dev/snd/hwC0D0 0x1a SET_AMP_GAIN_MUTE 0x7080

I tried all this, to no avail. At some point input stopped recording
sound, it has just offset, but I can't say which one was... if it's a
useful data, I can retry it.

And... I have almost never booted it, but I have a Vista installed in
this laptop. If you explain me how to do (in windows I am a dumb user) I
can try to search thing. What I know is that the sound in windows is
quite louder, and that recording works better. There is a button with
"offset correction" default on, if I remember correctly. 

Romano 

-- 
Romano Giannetti                            Dep. de Electrónica y Automática
http://www.dea.icai.upcomillas.es/romano    Univ. Pontificia Comillas (MADRID)


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
