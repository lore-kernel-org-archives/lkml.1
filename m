Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbZDLWjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbZDLWjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 18:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZDLWi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 18:38:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:44901 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZDLWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 18:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MIvsh8Q5yN4ZEcqr4R5nF973CvJokP/Vr2ohpWBrmjqjlsOJsFt/Eja3WsYafCuLIE
         JUCJZEjWgReFH7ZWkIsZsSxH4kqNu1grTphl+EstPyzjZ2POWQYX+DIK5rSJHLTdHaFg
         kOeNR0MuD11m2/8n875VG4Ewcmjj/ktvC3pYI=
Subject: Re: 2.6.30-rc1 (latest git): ACPI video backlight support broken.
 (WAS:thinkpad-acpi: cannot control brightness with hotkeys )
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <49E10684.5090101@gmail.com>
References: <49E10684.5090101@gmail.com>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 01:38:51 +0300
Message-Id: <1239575931.28597.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have an acer aspire 5720, and have same issue.
I don't use acer-wmi.
I use standard acpi video module, and now it doesn't work
nothing in /sys/class/backlight, and this in dmesg:

[  211.907597] ACPI: Failed to switch the brightness (using hardware
keys)

This is when I try to change brightness, and this on module load


> [ 1910.228636] ACPI Error (video-0537): Current brightness invalid [20090320]
> [ 1910.229006] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:34/device:35/input/input9
> [ 1910.390188] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> 
> 


Best regards,
	Maxim Levitsky

