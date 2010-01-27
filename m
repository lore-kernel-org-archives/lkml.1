Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132Ab0A0K0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0A0K0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0A0K0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:26:00 -0500
Received: from ks358108.kimsufi.com ([91.121.151.81]:53018 "EHLO
	mail.bercot.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0A0KZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:25:59 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 05:25:59 EST
To: <linux-kernel@vger.kernel.org>
Subject: Radeon HDMI audio in 2.6.33 kernel =?UTF-8?Q?=3F=3F=3F?=
MIME-Version: 1.0
Date: Wed, 27 Jan 2010 11:17:04 +0100
From: <debian@bercot.org>
Message-ID: <1457ffed8ff5fb0cf572cbc7384597a8@localhost>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I'm not sure I'm at the right place (please, if not, tell me where I can
find a solution...) but I have a problem with multimedia hardware.
So, I've changed my graphic card and I've bought an ATI Radeon HD 4550. My
goal is to use only an HDMI cable between my computer and my AV amplifier.
I've installed Debian Sid but I can't have any sound... Everything seems
OK with Alsa (and PulseAudio), but no sound !!!

With google, I've found this :
http://www.phoronix.com/scan.php?page=news_item&px=NzgxMA
[I should need a 2.6.33 kernel to have HDMI support with ATI cards]
So, I've compiled the 2.6.33RC5 kernel, but no difference !!!

The card seems to be OK :
# aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: HDMI [HDA ATI HDMI], device 3: ATI HDMI [ATI HDMI]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

Do you have any idea ?

Thank you.

David.
