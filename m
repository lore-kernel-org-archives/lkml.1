Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZDYCbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZDYCbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 22:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZDYCbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 22:31:38 -0400
Received: from n75.bullet.mail.sp1.yahoo.com ([98.136.44.51]:33170 "HELO
	n75.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751744AbZDYCbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 22:31:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 183662.6940.bm@omp103.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=2qYo6bFYoSXR3QRwK1qfhcX7sm0LIWDrjM5vWQvekXoEG+JeENYvp7mAB5olN7NIdkDuPgQo2TrJIXhe3qjwWwC6zEvof7YgS7DGI8GLdHFpQZTMGtZ7+5HSenXx281iLJXFMk0xFw5isTJXxXXfbLmulHMfxqm3Y4ybsrg3usQ=;
Message-ID: <113720.93163.qm@web112203.mail.gq1.yahoo.com>
X-YMail-OSG: cFSBXuoVM1nEgA1cjCGaGFXn_02h9ywz.P4r0syr316fa5DD0_S4lNU36Xlp2hf1X8u54LWoJPRnGMFg7mqSDCK0nMJr3MiWWvbIEQmF.xc8X1NgVB0Bv8jbL8iI0_tL938bMBOoDKMJjkI85y_0yt2cAGZjNeSsQaL410S9Mb3wlxfY94_pmXFn8twKGvs_xrtDpV1kQMBJRnxOx2N.IIOuE86iW193TjcI0MFVXuoW8L1vh38kGD_WcdFty0stLn0_TVa3n.aZgVT4jW3ORQi.mw2dArxru4AGcr2ojweWR_SGOJyMf29yB6jhK.DJiG6j3U1UsFQ_O7Z9gY1A2s3vqtu2wFy7sC0NmUgIrwmQTUbFQWxBjG42ksATnlALhc6zCtXlIHQ-
X-Mailer: YahooMailClassic/5.2.19 YahooMailWebService/0.7.289.1
Date: Fri, 24 Apr 2009 19:31:36 -0700 (PDT)
From: We La <w.landgraf@yahoo.com>
Subject: 2.6.30-rc3 : Regression: i915 , video
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On  -git1  was not included the fix for that regression.   :(

That regression means that on  compilations with 'normal' configuration and thus in almost all distros THE I915 KERNEL DRIVER DONT LOAD AND IS UNUSED, AND THUS ON MOST INTEL GRAFIC CARDS THE GRAFIC DONT WORK CORRECTLY, INCLUSIVE NO DRI/GLX.  Thus, this regression should be treated seriously and fixed.

Werner Landgraf
werner@sys-linux.yi.org


      

