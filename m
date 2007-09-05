Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXIEVFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXIEVFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbXIEVFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:05:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:14582 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbXIEVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tkdbWpB07T1sAZ7S0h5G/A4YTJXTj/QaPLsemnBUXcmM5g4iHYPF03CIu+aV/rtjKI0fV9/MBNnxAUVqq1cjX6yZ3RFhnPoUdKAQAtyNSz4ZTwLpnnCXCowVR6cHL8R2ZJXreZ2VvulMsRdeQ7Io52BEwSsh5PnQzHGk3vvRsp8=
Message-ID: <6bffcb0e0709051405v1e7ff4abjabe39373e4668d26@mail.gmail.com>
Date: Wed, 5 Sep 2007 23:05:03 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc5-git1-krf1 (known regressions fixes)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are a few patches for regressions that was not merged yet.

Subject         : 8250 claims non existing device blocking IO port
References      : http://lkml.org/lkml/2007/8/18/20
Last known good : ?
Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
Caused-By       : ?
Handled-By      : Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch           : http://lkml.org/lkml/2007/8/21/291
Status          : patch available

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available

Subject         : NFSv3 server error in LOOKUP after READDIRPLUS Call
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8966
Last known good : ?
Submitter       : Peter Kovar <peter.kovar@gmail.com>
Caused-By       : ?
Handled-By      : Neil Brown <neilb@suse.de>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12689
Status          : patch available

Subject         : linux-2.6.23-rc4 ppc build failure
References      : http://lkml.org/lkml/2007/8/29/154
Last known good : ?
Submitter       : Bret Towe <magnade@gmail.com>
Caused-By       : ?
Handled-By      : Tony Breeds <tony@bakeyournoodle.com>
Patch           : http://lkml.org/lkml/2007/8/31/1
Status          : patch was suggested

Subject         : Unable to access memory card reader anymore
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8885
Last known good : ?
Submitter       : Christian Casteyde <casteyde.christian@free.fr>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12438
Status          : patch available

Subject         : error: implicit declaration of function 'cfi_interleave'
References      : http://lkml.org/lkml/2007/8/6/272
Last known good : ?
Submitter       : Ingo Molnar <mingo@elte.hu>
Caused-By       : ?
Handled-By      : David Woodhouse <dwmw2@infradead.org>
Patch           : http://lkml.org/lkml/2007/8/9/586
Status          : patch available

http://www.stardust.webpages.pl/files/patches/krf/2.6.23-rc5-git1/

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
