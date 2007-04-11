Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbXDKPpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbXDKPpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXDKPpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:45:14 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:41246 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXDKPpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:45:12 -0400
Date: Wed, 11 Apr 2007 17:39:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Gene Heskett <gene.heskett@gmail.com>
cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <200704102354.23766.gene.heskett@gmail.com>
Message-ID: <Pine.LNX.4.61.0704111738370.32056@yvahk01.tjqt.qr>
References: <200704091007.58535.gene.heskett@gmail.com>
 <200704100351.33699.gene.heskett@gmail.com> <Pine.LNX.4.61.0704101809440.21664@yvahk01.tjqt.qr>
 <200704102354.23766.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 23:54, Gene Heskett wrote:
>>>>
>>>>So fix tar to not do silly things.
>>>>Kernel major:minor numbers are not stable.
>>>
>>>YOU Tell that to the tar/star people, they are flabbergasted that its
>>> not stable.  It apparently is for every other OS tar can be run on.
>>
>>FreeBSD also seems to be quite "dynamic".
>>/dev/da0 is (0,92) for the 'fixit shell' -- how about you?
>>
>I don't have such a beast here.  Whats that supposed to do?

Well I was just pointing out that Linux is not the only one to have device
numbers (for promiment block-backed storage) that can move across reboots.


Jan
-- 
