Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab0BVHEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 02:04:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40857 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0BVHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 02:03:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=peneGJ1MuHG0ZN0ao+3No+6yHfLJJCSR3uejXGQXT14ytdwo1NGn6h5TI8Y9/CHjYB
         ZJwfAhzJNF2r/DfC/ZabKtRQGX4EmEvkpSEhfyHrYEgJTGRw6IZqIeDePI902N+aj+Yc
         daVoBV+JNDiYYtfqQ2w6OJqdPwf4pVH1UVGyU=
Date: Sun, 21 Feb 2010 23:03:51 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc8
Message-ID: <20100222070351.GC2095@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Hopefully this is it for .33.

Changelog:
---------

Roy Yin (1):
      Input: usbtouchscreen - extend coordinate range for Generaltouch devices

Samu Onkalo (1):
      Input: polldev can cause crash in case when polling disabled


Diffstat:
--------

 drivers/input/input-polldev.c              |    6 ++++++
 drivers/input/touchscreen/usbtouchscreen.c |    8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
Dmitry

