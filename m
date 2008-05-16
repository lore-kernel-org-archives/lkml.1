Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYEPGSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYEPGSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYEPGRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:17:51 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:64625 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYEPGRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IHzQP7ZTxtrmG5UL9QIBmtUD3DpBKx5C08OxqjCaziVLOP+ftTiBfpqSSKFnP33C51ZSQXr5AYwaT7lVJzXa6aasD4SONWzna0Wo6sGan47P4CaZ2QEWK6SLF5Vjdj0tnnZLsfX88a666y2i7YOxQvx6zKGKU/pJzbToEQCbAVE=
Message-ID: <dd18b0c30805152317k2d0d9dfbp27ddf7929109292e@mail.gmail.com>
Date: Fri, 16 May 2008 06:17:48 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ACPI : EC: GPE
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I'm noticing this with the latest git
 dmesg:[    0.943919] ACPI: EC: GPE = 0x17, I/O: command/status =
0x66, data = 0x62
dmesg:[   11.486870] ACPI: EC: GPE storm detected, disabling EC GPE
dmesg.0:[    0.943919] ACPI: EC: GPE = 0x17, I/O: command/status =
0x66, data = 0x62


I will see this on various boot's.
regards;


-- 
Justin P. Mattock
