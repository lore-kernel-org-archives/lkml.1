Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXIFVsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXIFVsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932446AbXIFVsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:48:38 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:57287 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbXIFVsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:48:37 -0400
Subject: Re: hda_intel : Patch + Regression in 2.6.18 -> 2.6.22
From: Romano Giannetti <romanol@upcomillas.es>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
In-Reply-To: <s5hir6n6ck6.wl%tiwai@suse.de>
References: <20070822222902.GA28563@computer-surgery.co.uk> 
	<20070905083844.6637da1e.akpm@linux-foundation.org> 
	<s5hlkbl6qsn.wl%tiwai@suse.de> 
	<20070905091633.87cfaa81.akpm@linux-foundation.org> 
	<s5hhcm96oza.wl%tiwai@suse.de> <1189091390.3212.3.camel@rukbat> 
	<s5hir6n6ck6.wl%tiwai@suse.de>
Content-Type: text/plain;
	charset=utf-8
Date: Thu, 06 Sep 2007 23:48:33 +0200
Message-Id: <1189115313.7275.5.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 17:25 +0200, Takashi Iwai wrote:
> At Thu, 06 Sep 2007 17:09:50 +0200,
> Romano Giannetti wrote:
> >
> >
> > Just one hand up: I haven't tested the patch pointed to by Andrew, will
> > do asap, but it seems that contains the changes from
> >
> > https://bugtrack.alsa-project.org/alsa-bug/view.php?id=3104
> >
> > which are needed to have sound at all on my toshiba (although with some
> > remaining problems).
>
> No, it's a different one.  This Toshiba model is still not supported
> well.  The patch in mm tree is basically equivalent with the latest
> ALSA HG tree, so if you tested ALSA HG version (or daily snapshot),
> it should be same.

Unfortunately you're right. The patch I posted to the alsa bugtrack,
extracted from the pshou files, works for me. The alsa-git patch gives
me a system without sound.

>
> I'm still waiting for a patch from pshou for the latest version, but
> no reply yet.	m here. I can  try to "merge" pshou patch with the
> alsa-git, but I'm not so confident about my understanding of the
> thing...

Thanks again
	Romano


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

