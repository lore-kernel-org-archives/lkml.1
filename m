Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYL1Mj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYL1Mj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 07:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYL1Mjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 07:39:48 -0500
Received: from mail.iwoars.net ([88.198.9.16]:38462 "HELO
	eristoteles.iwoars.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753829AbYL1Mjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 07:39:48 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2008 07:39:47 EST
Date: Sun, 28 Dec 2008 13:33:05 +0100
From: Thomas Themel <thomas@themel.com>
To: linux-kernel@vger.kernel.org
Subject: XFS corruption on ARM
Message-ID: <20081228123305.GE30805@themel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Jabber-ID: themel@amessage.at
X-ICQ-UIN: 8774749
X-Postal: Rubensgasse 9/12, 1040 Wien
X-Phone: +43 650 9903486
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there was a thread[0] on this list in 2008-10 about XFS corrupting
rather quickly on recent ARM kernels, which seems to have petered out
without any apparent results. I'm still seeing the same problems with
2.6.28, and I suspect that this qualifies as a kind of regression
(though ancient), since the devices I'm running this on (Buffalo
LinkStations) originally ship with a (vendor-modified) 2.6.16 kernel,
where XFS seems to be working.

Is this still on anyone's radar? I'm willing to test proposed fixes and
supply data[1], but lack any deep knowledge of either ARM or XFS internals.

(Please Cc: me, I'm not on the list.)

[0] http://lkml.org/lkml/2008/10/1/382
[1] Though mine doesn't look any different from what was posted in [0]
    to the little-trained eye.

ciao,
-- 
[*Thomas  Themel*]
[extended contact] But let your communication be, Yea, yea; Nay, nay:
[info provided in] for whatsoever is more than these cometh of evil.
[*message header*]      - Matthew 5:37
