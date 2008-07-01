Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbYGADWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbYGADWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 23:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYGADWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 23:22:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45347 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYGADWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 23:22:14 -0400
X-Sasl-enc: 47RGzkL4ngJH6eMPWV6A2M/EUJVWgSSFm7z4BH07/tXw 1214882533
Date: Tue, 1 Jul 2008 00:22:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc5-git2: snd-emu10k1 does not work
Message-ID: <20080701032207.GA24719@khazad-dum.debian.net>
References: <200806082303.59245.rjw@sisk.pl> <200806301158.47783.rjw@sisk.pl> <s5hzlp3f9o6.wl%tiwai@suse.de> <200806302236.45838.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806302236.45838.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Rafael J. Wysocki wrote:
> Still, it's interesting why the openSUSE kernels work with the card without
> any problems while the kernel.org ones apparently don't.

Same config?  Particularly, same config for CONFIG_SYSFS_DEPRECATED_V2 and
other such small details?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
