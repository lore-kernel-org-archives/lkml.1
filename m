Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZDCE5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZDCE5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZDCE5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:57:45 -0400
Received: from n1.bullet.mail.re3.yahoo.com ([68.142.237.108]:46100 "HELO
	n1.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751980AbZDCE5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:57:44 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2009 00:57:44 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 996917.4205.bm@omp105.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=sQ+O3xXRYziyDaWrGWZAdoBtTK7XGDFrMmyzbYNx8Vngt8wQV4nWWbB1ibD1PLRwzbX/+5BTm6COgdWUDjn3tSmQYnmFKlQ/fz1P9PeUZvkR5vLLJNSyZ/RyECBSToRzMuZHCRt52p9/ahT6QdKr0FrwxcUASCSPOruYKHfHQFE=;
Message-ID: <843756.2736.qm@web112207.mail.gq1.yahoo.com>
X-YMail-OSG: D2S8fxMVM1nWUcdPNNUPriFcKx_RYTUxATz8_3MVCpzy3lZgTmx6dZN_ZBA2R4nVWBlmto2hkVDc4w2gQx3laZfcOwaEyEZouYuzYjOmig.2mlKrRlBewHxMDwmlj3EYcAhQK4pbM32.QOB0r1QfzVsz5AHbv4YN5i0B69JwRAC2P972V2M7bJPOwGOWmdyMs4ohpyObHRpClzze0v3A5y08D__Uur0HXSou7rS33fWdew_wfD9s9qyrmXKontMuPZ8orGneFFQBhN9uC0.PGXKWgssDASCUylAGh0BLyKo9UUsy8Pm.PGQ7KBioNfuKA.O3syeLPX7TrBIyhjsVpJ0ZR83XHs6f3gpC2w--
X-Mailer: YahooMailClassic/5.2.15 YahooMailWebService/0.7.289.1
Date: Thu, 2 Apr 2009 21:51:12 -0700 (PDT)
From: We La <w.landgraf@yahoo.com>
Subject: regression : kernel error instead of automount mobile phone
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Message from syslogd@localhost at Tue Mar 31 21:50:22 2009 ...
localhost kernel: Code: 00 8b 45 f0 c7 86 9c 00 00 00 10 32 7e f8 89 86 90 00 00 00 8d 86 94 00 00 00 89 86 94 00 00 00 89 86 98 00 00 00 8b 02 8b 78 0c <0f> b6 47 03 83 e0 03 83 f8 03 75 06 80 7f 02 00 78 45 c7 45 dc 

 Message from syslogd@localhost at Tue Mar 31 21:50:22 2009 ...
localhost kernel: EIP: [<f87e3f9f>] wdm_probe+0x17f/0x3f0 [cdc_wdm] SS:ESP 0068:e84c5dbc

=====
Phone Sony-Ericson 
On connecting via USB, comes the error message above. Kernel 2.6.29.  With 2.6.26.2 (all oter things the same) no problem, it automounts and opens the window with the file list.

Werner Landgraf
Linux SYS  http://ftp.tu-chemnitz.de/pub/linux/SYS/





      

