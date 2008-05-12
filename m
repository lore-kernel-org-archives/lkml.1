Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYELOHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYELOHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYELOHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:07:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:35962 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYELOHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=uEKCPVXhUKafaAsjTKoDsClGUsfto1boRYTJIoRhss53BQiwXFAMlNJh4qUZDUnh1JkGGWirHjRRzlPry8Hb5vPe3Mke5asMPB56lxMWMxMFOnPfxnTgAy9LhbWlGC/l5TxyCnXh9Q050bsdpCU5qNniY0KHw77Ywk8jLcydWGQ=
Message-ID: <31e679430805120707w41dddb5h53b1ff00d2cc9819@mail.gmail.com>
Date: Mon, 12 May 2008 17:07:12 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: ReiserFS or USB ??
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 1e671f7518cfe7b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm having some troubles with my external harddrive formated with reiserfs...

After using for some time, it just disconnects and dmesg shows me this:

[276439.361676] printk: 1917173 messages suppressed.
[276439.361684] Buffer I/O error on device sdd1, logical block 74823373
[276444.306477] printk: 1923272 messages suppressed.
[276444.306485] Buffer I/O error on device sdd1, logical block 74823373

Several times.
Would this be usb trouble on reiserfs trouble ? (It looks to me usb issues).

I'm using 2.6.25

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
