Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbZL2TnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbZL2TnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZL2TnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:43:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44513 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZL2TnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lC8Y+iisIBEVKeBvXCB8tGGeX05mpsotL2iCqbxO2lcoIWSO3h7PFtdKjW7B4u8koL
         U+/nToD5nRdgQ46CqbT1sHw6NyqvWGIKUS9L2PTRENpvU98Hcwu1/shBRZ5RK5NUu25G
         9SV8M4zCRk4zm1kG3R/iu53WGss1vCilanMZ0=
Message-ID: <4B3A5BC2.10207@gmail.com>
Date: Tue, 29 Dec 2009 20:42:58 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       =?UTF-8?B?TcOhcnRvbiBOw6ltZXRo?= <nm127@freemail.hu>
Subject: Re: 2.6.33-rc2: Reported regressions 2.6.31 -> 2.6.32
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
In-Reply-To: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote, On 12/29/2009 04:26 PM:

...
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
> Subject		: IP address assigned by DHCP is dropped after ~40 seconds
> Submitter	: Márton Németh <nm127@freemail.hu>
> Date		: 2009-12-13 08:59 (17 days old)
> 


IMHO this bug might be considered as fixed by updating a userspace tool
(KNetworkManager) - unless somebody wants to seek for the exact reason...

Jarek P.
