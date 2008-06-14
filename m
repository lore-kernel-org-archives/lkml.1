Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYFNJoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYFNJoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYFNJoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:44:04 -0400
Received: from n2a.bullet.mail.in2.yahoo.com ([203.104.19.40]:39195 "HELO
	n2a.bullet.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755937AbYFNJoB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:44:01 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2008 05:44:00 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 88567.45378.bm@omp111.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=svFDdqc+LziOAJrXUnwegEbFIJE+lRMgLXXpyGI3HdkotDXmpQG5rwQnCdkg2IiP2JiSQJITu7qZ8i/SCMxyPOe1wMG/axsSgMVRv2CYxNxy6eOog/rQVfGEVqOVQc71OGLflLnPb7Y8l2Qs8CM3iOaeJvzOIQoHfsBvj+ap8Ig=;
X-Mailer: YahooMailRC/975.45 YahooMailWebService/0.7.199
Date: Sat, 14 Jun 2008 15:07:17 +0530 (IST)
From: vinoth kumar <boovino@yahoo.co.in>
Subject: posiflex printer
To: linuxkernel mailinglist <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <821204.74640.qm@web94512.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a posiflex thermal printer PP7000. Its connected through USB-Serial bridge. As i connect the printer i could see /dev/ttyUSB0 getting created and pcscd run in foreground does print that it could detect the bridge. Its a text only printer and i am running 2.6.22 kernel (Ubuntu). i could print by directly sending data to /dev/ttyUSB0. but  CUPS couldnt find the printer could anyone figure out whats the problem.
I even compiled that ftdi_so module and added it still it doesnt detect.


      Share files, take polls, and make new friends - all under one roof. Go to http://in.promos..yahoo.com/groups/

