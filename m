Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYEDHiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYEDHiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYEDHhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:37:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:5025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYEDHhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IlgKBF3jb5LtNbv9k0xVdAgqpK6D0t9lKQmJFo8RQgvitZqzHJbHm/PDMJWldV4tGwg2cACE/O4XUakuyHx6Skyzdz/qTEEwpGFN8Wf562ffHNalsIeAJNE3uRzElCp4PjnX9DCiAtq4a2YuYhfnr1qJEbqlXqAXdTGp25D+RHs=
Message-ID: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
Date: Sun, 4 May 2008 09:37:54 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Suspend to memory is freezing my machine
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
complete freeze of my T61 during suspend. (dual core, 2GB).

I'm running kernel with no_console_suspend - but all I can see is
blinking cursor on an empty screen - thus even when I run kernel with
most debug options turned on, I can't pass more details so far.  I run
suspend with with SD card in - so maybe some update in the MMC driver
might be responsible for this ?

Also - I think that option no_console_suspend doens't work correctly -
as many times with suspend I do not see any log message on my console
screen. However sometimes the log is shown.

Zdenek
