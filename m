Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXAaTvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXAaTvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbXAaTvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:51:52 -0500
Received: from web26011.mail.ukl.yahoo.com ([217.146.177.33]:41651 "HELO
	web26011.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932169AbXAaTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:51:51 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 14:51:51 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=Q6KYCUi/QzdgxL1nFO7Uhh0HWA63dr02N/BNZLyazhjvkQjBjP6GEU27eDPqz+b1Q16d+14VOB8cEGWhR0Rl/NnHOxVuYx7gyg4/7P8iBuVKiUD7DQBrsn5k6jfZygBbwDRr2buTJ9xivA1vZDj7mQzJ+4B2Tp9eFpOMsvTgia8=;
X-YMail-OSG: 8m1BddoVM1maeB9EhVJITdgalznfLO64i5Q2hL_XQL2flQbKrc0Gx1PjLPnmAijUOsVSxpSqfcGfkZHt2oP4zuSIVtg07Ejf08eEVnHNQVpBVTpPdfCVPv9kd9btZkDQmL6JYdK1qhqo4p19AmDgv0cb2FJzB37ZEYIra148KiQs..a277kNfIX1Ew--
Date: Wed, 31 Jan 2007 20:45:09 +0100 (CET)
From: <nahidesafe-kernel@yahoo.it>
Reply-To: nahidesafe-kernel@yahoo.it
Subject: wireless kernel driver porting
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <522043.87100.qm@web26011.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, I've bought a USB wireless TA bundled with GPL
Linux drivers for 2.6.11 kernel series.
The driver seems to compile fine with 2.6.15-gentoo-r1
on x86, but can't be used on x86_64 systems.
Technical support can't provide a porting of the
driver in the short time.
It seems that there are no driver included in the
current kernel tree for this wireless TA:
Conitech Dakota Wireless TA 56Mbps.
The driver provided is the IS89C35 Wireless Linux
Driver 3.0.47.0, copyrighted by  Winbond Electronic
Corporation, ISSC and released with
MODULE_LICENSE("GPL");

I haven't a ftp server where to put the driver tarball
so if you can help me tell me where I can send an
email with the driver as attachment ~500kb.
Please CC me in your reply, I'm not subscribed to the
list.



	

	
		
___________________________________ 
Vinci i biglietti per FIFA World Cup in Germania! 
yahoo.it/concorso_messenger
