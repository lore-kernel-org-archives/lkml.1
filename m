Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZBVRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZBVRBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZBVRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:01:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZBVRBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:01:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: jacques <ocean4200@gmail.com>
Subject: Re: no sound with DIGITAL INPUT
Date: Sun, 22 Feb 2009 18:00:56 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
References: <49A175E4.6070608@gmail.com>
In-Reply-To: <49A175E4.6070608@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902221800.57032.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing Takashi)

On Sunday 22 February 2009, jacques wrote:
> Hello,
> 
> I have a giga-byte GA-EG43-S2H with an integrated REALTEK ALC888 sound 
> card. I'm unable to use the digital INPUT while recording or using pipe 
> (arecord -M -D iec958 -f dat | aplay -D iec958 -f dat). Also, the 
> giga-byte GA-EG41-S2H has the same problem (uses the same sound 
> chipset). The giga-byte GA-EP45-UD3R is working perfectly but it uses a 
> different sound chip (ALC889A). I tried a lot of things like changing 
> snd-hda-intel model (auto, 6stack-dig, 3stack-dig, etc). I upgraded the 
> ALSA sound driver to the latest version (1.0.19) and also used the 
> snapshot. My distribution is Ubuntu 8.10 (server edition) 64 bits. I 
> also installed the desktop version of it without success. I tested the 
> digital input on Windows operating system and it works perfectly. Now, 
> I'm not sure if I'm missing something with the configuration or it is a 
> problem with the ALSA driver or the kernel module itself.
> 
> Look at the outputs from alsa-info script (computer outputs for details):
> http://www.alsa-project.org/db/?f=068933737fa64bc43928b06d2f4b4559986e6439
> 
> Thank you for helping me to solve this problem.
