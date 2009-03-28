Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZC1VJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZC1VJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZC1VIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:08:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:8224 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbZC1VIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer:thread-index:content-language;
        b=MQ6Lutq/c246PLw+v2FfHG/B35v90Q5XTv/RoeD8hm/z6yp4nYwepfnng2UYHIsmoD
         Bkr+3uCpehBRim1kGzQD8/7KO/GC/3cK8kRH6SJK5z9FfiGHoFqc0RzJPzKpdttS5AHl
         MKStH6GngfCjsuMOrRL+fOxT1BqkBXSbhD8qw=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: 2.6.29 network hosed?
Date: Sat, 28 Mar 2009 14:08:39 -0700
Message-ID: <01fc01c9afe9$5ecb43b0$1c61cb10$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acmv6Vz2/Pn8UgPSSK2TMO/OM/5rRA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I downloaded 2.6.29 and the network seems to be hosed on my desktop. Normal
ssh is fine, or light use of network. But whenever I run a perforce
integration the entire box just becomes completely dead on me. No traces,
warnings or printks. 100% reproducible. It's a FC4 based system (I know,
pretty old) for development.

I only have an USB keyboard attached and it's not recognized after boot, so
no sysrq traces. Probably I have to upgrade udev? I can still use the
keyboard on the grub boot menu though.

If it's a known issue please let me know. I'd be glad to test any patches.

Hua

