Return-Path: <linux-kernel-owner+w=401wt.eu-S1751632AbXBOPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbXBOPe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXBOPe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:34:29 -0500
Received: from webmail16.mail.yandex.net ([213.180.200.38]:33702 "EHLO
	webmail16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXBOPe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:34:28 -0500
X-Greylist: delayed 1529 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 10:34:28 EST
Date: Thu, 15 Feb 2007 18:08:41 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D47779.000006.08064@webmail16.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: cat, cp operations for tty driver (like for char one)
X-MsgDayCount: 4
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.220.38
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about linux tty driver 

how to support cp, cat operations in tty driver (like tiny_tty)?
(e.g. echo "hello tty" > /dev/ttyS3, cat < ttyS10 etc)

There a lot of examples with char drivers, but I could not find it for tty Linux driver. 


