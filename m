Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZHFUR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZHFUR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZHFUR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:17:28 -0400
Received: from web26108.mail.ukl.yahoo.com ([217.146.182.149]:36740 "HELO
	web26108.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756171AbZHFUR1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:17:27 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 16:17:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5zQAQqgggGpDKLYtMojHOWWG6zPTKfkPpoj02081nOaKIMTlKEGPwvvA402yNrW+BL7P0xz4HouANLMoT+plWReaQJnPS5H9UsImwKPZ/O9j2oW+mkC/JQ+28x1RX6anRT66Ejql5HCLZRGGqoUG4H6dX5Tko97zn2o/NIPASXg=;
Message-ID: <281886.98991.qm@web26108.mail.ukl.yahoo.com>
X-YMail-OSG: _QaArBoVM1km9ut97mQDM93xIhAyB4ITZwOybn74uAv0HZ1z9hL32mZyQBfmd7cP2Ngc6OxTwm48QJYuhzKZnfioYwiFGwFlwLzUvqGHOaNL8RVom__nZph9A4ePwhcXP5JOGWtAfD501rDY_9K.b0POmB097kIY4IK02WNPl_WK_eaCT86Dd_qfhUJ2ZCSi8w4Q6WF8aWObOooy7bVicTJQS3kQD6.vRkovGowYi12p1dexUxJLlrDNXMf_qDlQzukk0d3GPTZg3KvyGKl.Gm_mfafoFbjsvjev7wZs.7erH.md_JNPExmNfrsXonXM6cB.fPe0Qy69honBw1g0.8TD226b4IPkJy0-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Thu, 6 Aug 2009 20:10:45 +0000 (GMT)
From: linuxcbon <linuxcbon@yahoo.fr>
Subject: modprobe acpi-cpufreq FATAL: Error inserting
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an AMD Athlon 64 X2.
I did :
# modprobe acpi-cpufreq
FATAL: Error inserting acpi_cpufreq (/lib/modules/2.6.30.1/kernel/arch/x86/=
kernel/cpu/cpufreq/acpi-cpufreq.ko): Device or resource busy

I thought that module was general...I know there are other modules for each kind of processors, but can you make one module for all processors or do we need to use the specific ones ?

Cheers.



      
