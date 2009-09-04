Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZIDFF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZIDFF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbZIDFF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:05:27 -0400
Received: from mail-px0-f177.google.com ([209.85.216.177]:35769 "EHLO
	mail-px0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZIDFF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:user-agent:message-id;
        b=xNjhAMCv7GbZoXf/OgpiQye1Nzs97rOw4Uz9un85bGbH70skkj/1BftIFSu3Jvb6mQ
         SPvqVaxpiV4JF82e+A/yLZfjfSONZ1EYpqd8JA/MYtV10YyJJDNjSjH0d8MBz3tvi9RH
         hi+/fkqxT/HAv24LgEf82bEU/Mt4ybVK2sago=
Date: Thu, 3 Sep 2009 22:05:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.31-rc8
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090904053822.CCA13526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dave Andrews (1):
      Input: atkbd - add Compaq Presario R4000-series repeat quirk

Dmitry Torokhov (1):
      Input: i8042 - add Acer Aspire 5536 to the nomux list


Diffstat:
--------

 drivers/input/keyboard/atkbd.c        |   35 +++++++++++++++++++++++++++++++++
 drivers/input/serio/i8042-x86ia64io.h |    8 +++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

-- 
Dmitry

