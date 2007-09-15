Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbXIOUUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbXIOUUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 16:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXIOUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 16:20:25 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:45893 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbXIOUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 16:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ei9pa5R3Fhi995+djxBkzafqEeuAwzNULMtFGFaYJX7ISDiDEG94C/82DcK91fJHE2UAmqYLb8ACcb45kJx7oTVYV4fQ9pMqbWCrVacLAXM3ZVbDys3s53wyh/szWzqIdloIjTGpUzveo1j9JhTxd7aLziun+w+rGQc5NDcn1RU=
Message-ID: <8b67d60709151320h1f363b4cl57023627d8139680@mail.gmail.com>
Date: Sat, 15 Sep 2007 21:20:22 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Latest git won't compile
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CC      drivers/char/tty_ioctl.o
drivers/char/tty_ioctl.c: In function 'n_tty_ioctl':
drivers/char/tty_ioctl.c:799: error: implicit declaration of function
'kernel_termios_to_user_termios_1'
drivers/char/tty_ioctl.c:806: error: implicit declaration of function
'user_termios_to_kernel_termios_1'
make[2]: *** [drivers/char/tty_ioctl.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2
