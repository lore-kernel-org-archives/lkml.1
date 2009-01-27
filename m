Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZA0UX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZA0UX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZA0UXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:23:17 -0500
Received: from n6.bullet.mail.ac4.yahoo.com ([76.13.13.234]:37333 "HELO
	n6.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752786AbZA0UXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:23:17 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 15:23:16 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 854099.10661.bm@omp108.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=yuzOzlrS050mNgnrc9nxZ/4i4WT7Bf4Rw5IrgrVwPCpC7wm6u82AYvmhjqS+Zfx+rws93ku8+cDzbb6xRGCLdG5ERuWM/M7X+C4nqK/Ri+u5JUJqE/7kbXjLfupcQGWBK9BzYYbFO84RCtKKFFEE7RT/svNmj2eNCKd3FQeeceY=;
X-YMail-OSG: igvVr7gVM1mBAuyo5GLuN9GfHl4x.kN2jAxDFeSsHzHCIdJxDyZAu1pGptHCeK3spoVVtRuM7x19Ea5.YOHsjuIzjSm8ePgkspdVFYNRM_SK4AZjUKtLQZ4wJ25P220M5htla_Ze5bMjhHcJkimm8E0lw2Q-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 27 Jan 2009 12:17:25 -0800 (PST)
From: Xiaoning Ding <dingxn@ymail.com>
Reply-To: dingxn@ymail.com
Subject: a question about p4_clockmod module on Xeon quad core processors
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <603382.20833.qm@web59902.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I have tried the p4-clockmod module in Linux kernel 2.6.29 on Xeon 5355 quad-core CPUs with no luck. It seems current p4-clockmod driver still cannot support Intel Quad core processors, right? 

I know I can also use acpi-cpufreq. It can only scale down the frequence from 2.67GHz to 2GHz. But I need some lower frequencies for some experiments.

Thanks!

Xiaoning 


      

