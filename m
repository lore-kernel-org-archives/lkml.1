Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbXHEQjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbXHEQjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXHEQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:39:42 -0400
Received: from web33705.mail.mud.yahoo.com ([68.142.201.202]:29828 "HELO
	web33705.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757058AbXHEQjl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:39:41 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 12:39:40 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=makp38u6JeT9kCYScF1+OmhE8wFUuU4SM2so1ivD7BrE159/k7aFgLiwcUrTxt3khRZpFic7vDHpDSexSV8FtVWnY45wAf6UBx52RZBPBEDrPjt6nnvBy73i2hSrz+4I6quL5QIiEdDb5mL7fQI7z7yKRGpu1sJvXz/uR5D4z4g=;
X-YMail-OSG: Bafg47IVM1kR1543xlL_e7sYpzleXwn8stm6HJ86O6EN9tsnoAaQ.0i.t5eZXYeFhwEAs0TA6UnIsBnWCt1NcwvtKtIjCcP.54K54DLtDQZR.0i8TRDlOsHoiiPb4w--
X-Mailer: YahooMailRC/651.41 YahooMailWebService/0.7.119
Date: Sun, 5 Aug 2007 09:32:59 -0700 (PDT)
From: Adnan Khaleel <akhaleel2001@yahoo.com>
Subject: Page Cache Question
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <725937.57185.qm@web33705.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm looking for a way to disable the page cache for an
experimental NUMA system running the 2.6.17 kernel. I would prefer to
only disable the page cache for my process and still have it be enabled
by the rest of the system. Is there an easy way of doing this?
Alternatively, I would be fine disabling the Page Cache altogether as well.



Thanks



AK






       
____________________________________________________________________________________
Pinpoint customers who are looking for what you sell. 
http://searchmarketing.yahoo.com/
