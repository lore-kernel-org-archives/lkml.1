Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbXIJMve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbXIJMve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXIJMvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:51:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53332 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759505AbXIJMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:51:13 -0400
Date: Mon, 10 Sep 2007 13:59:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Broken mail setup
Message-ID: <20070910135912.29ad26e8@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will RMK (rmk@arm.linux.org.uk) please fix his email setup otherwise I
can't send serial/tty/arm stuff to him.

"<<< 550 You have no reverse DNS; please try again when you have resolved
that error 554 5.0.0 Service unavailable"

Difficult to tell what you've got wrong but the delivering host does have
a reverse DNS, and the mail address is an MX so if you are trying to turn
that into a reverse A record you have some problems with your scripts.

Alan
