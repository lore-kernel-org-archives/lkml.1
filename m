Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXIJIqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXIJIqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 04:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbXIJIqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 04:46:45 -0400
Received: from ic0245.upco.es ([130.206.70.245]:52315 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbXIJIqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 04:46:44 -0400
Subject: Toshiba A305 hda-intel (Was: Re: easy alsa patches for the 
	stablekernel?)
From: Romano Giannetti <romanol@upcomillas.es>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, perex@suse.cz, pshou@realtek.com.tw
In-Reply-To: <s5hr6lahwkw.wl%tiwai@suse.de>
References: <20070822222902.GA28563@computer-surgery.co.uk> 
	<20070905083844.6637da1e.akpm@linux-foundation.org> 
	<s5hlkbl6qsn.wl%tiwai@suse.de> 
	<20070905091633.87cfaa81.akpm@linux-foundation.org> 
	<s5hhcm96oza.wl%tiwai@suse.de> <1189091390.3212.3.camel@rukbat> 
	<s5hir6n6ck6.wl%tiwai@suse.de> <1189115313.7275.5.camel@rukbat> 
	<1189153347.15955.5.camel@rukbat> <s5h7in26aj3.wl%tiwai@suse.de> 
	<46E13E31.1050409@leemhuis.info> <s5hy7fi4oou.wl%tiwai@suse.de> 
	<46E1A9AC.1050601@leemhuis.info> <1189198747.13399.10.camel@rukbat> 
	<s5hr6lahwkw.wl%tiwai@suse.de>
Content-Type: text/plain;
	charset=utf-8
Date: Mon, 10 Sep 2007 10:46:41 +0200
Message-Id: <1189414001.24722.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-08 at 01:42 +0200, Takashi Iwai wrote:
> At Fri, 07 Sep 2007 22:59:07 +0200,
> Romano Giannetti wrote:
> >
>
> It's on git.kernel.org, perex/alsa.git tree mm branch.
> You can find the information in the download wiki page of
> alsa-project.org.
>

Ah thanks,

	found. Now, I'd like to know if anybody has any hints over the problem
of the offset in the ADC output offset [1] (which is the Mic/Front Mic
input offset, that is). I'd like to know if this is a problem of this
specific hda-intel chip or if it's a more extended problem, and I am
quite willing to help to solve it. It's quite easy to spot with
audacity.

Booting in Vista (for the third time since I bought the thing) I noticed
that there is a "offset compensation" flag in the sound control panel,
maybe it's related...

[1] https://bugtrack.alsa-project.org/alsa-bug/file_download.php?file_id=2129&type=bug

Romano

--
Romano Giannetti --- romano.giannetti@gmail.com
Sorry for the following disclaimer, it's attached by our otugoing server
and I cannot shut it up.



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

