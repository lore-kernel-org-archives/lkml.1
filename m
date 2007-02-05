Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXBESNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXBESNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXBESNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:13:54 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:35380 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932379AbXBESNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:13:52 -0500
X-VirusChecked: Checked
X-Env-Sender: Scott_Kilau@digi.com
X-Msg-Ref: server-15.tower-29.messagelabs.com!1170699200!31320506!7
X-StarScan-Version: 5.5.10.7.1; banners=-,-,-
X-Originating-IP: [66.77.174.21]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.20 doesn't compile with gcc-3.2.2
Date: Mon, 5 Feb 2007 12:13:20 -0600
Message-ID: <335DD0B75189FB428E5C32680089FB9F012DCBBE@mtk-sms-mail01.digi.com>
In-Reply-To: <200702052104.36388.a1426z@gawab.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.20 doesn't compile with gcc-3.2.2
Thread-Index: AcdJT8SeA/Rvf5UwSDqwQpol3y39gwAABR4w
From: "Kilau, Scott" <Scott_Kilau@digi.com>
To: "Al Boldi" <a1426z@gawab.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Feb 2007 18:13:21.0778 (UTC) FILETIME=[51DA2D20:01C74951]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,
 
> What was your binutils version (# ld -v) before and after the upgrade?

I was on the "last" version of binutils that Red Hat 9 had, which was:
binutils-2.13.90.0.18-9.i386 


I went up to the prebuilt version of binutils from Fedora Core 3:

[root@scottk7 tmp]# ld -v
GNU ld version 2.15.92.0.2 20040927
[root@scottk7 tmp]# rpm -qa|grep binutil
binutils-2.15.92.0.2-5.1


Scott

