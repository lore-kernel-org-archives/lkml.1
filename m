Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZA0AeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZA0AeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZA0Adw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:33:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:33682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZA0Adv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=SNgLecoMC+8oKlNcscqwnZh0dqaWtrQM9iAT7Bwo1FNGsOuu1WNp02h6rDFRdo62VK
         ujudJ2A5hSi6Z0exoOfToeLv9hKlLuvegIhk/o4ZZaWuYcPffuOu65oeCiL+YJORdjWz
         VXgRtovYJUXv2CBTDjbky7mhgiep+8h8aa5bk=
MIME-Version: 1.0
Date: Tue, 27 Jan 2009 01:33:50 +0100
Message-ID: <36d886900901261633r3b3018b4led0bd980816f4d88@mail.gmail.com>
Subject: SYS_rename for FAT32
From: Nicklas Widlund Bjurman <lordmetroid@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm a new Linux kernel developer.

I filed a bug two weeks ago( https://bugs.launchpad.net/bugs/315782 )
and now after some further research to determine the bug's location, I
am now determined to patch it.

I searched http://lxr.linux.no/linux+v2.6.28.2/+search after
SYS_rename to see what the process is for renaming a file however I
can't find anything. Could anyone knowledgeable of the kernel point me
to where I should start digging?

Best regards
Nicklas W Bjurman
