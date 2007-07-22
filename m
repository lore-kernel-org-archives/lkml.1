Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbXGVAtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbXGVAtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 20:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXGVAtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 20:49:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:18518 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbXGVAtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 20:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eTYRZ/cFg/kQjBuCoZjPfa3w4oI/REvhEnZ0cByNTgkQUd3/ESgx/gf1JDtFiTbcfW4uCgT9ir6hXdvF3rwShin1enJYyVS9OlIk5Ebrl/qIj1enTseAUkFOLSWaL7n784uC3xGrTk5mxRc2iK5mp1Q/jaAljujEl5XZqGArvnI=
Message-ID: <86802c440707211749s10c2e97bl1e0a3b86714916d9@mail.gmail.com>
Date: Sat, 21 Jul 2007 17:49:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 0/3] x86_64: apicid_to_node when acpi=off or no srat
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

Please check the three patches about the apicid_to_node initialization
when acpi=off or srat is not defined with BIOS.

Thanks

YH
