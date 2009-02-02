Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbZBBRLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbZBBRLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbZBBRLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:11:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:2530 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZBBRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:11:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=xm7RD5awt2QcaqPa0B468Q1ng7dzncUyfSPz8biy2lowSqCCJ+b5AfdJXpncBuhpo2
         MbxHsxDD8nIz4vIq34q6QhBZ1v46SKFYJ2uku7JH70mWOYt4mbO0RCrsXify8FBUb0oO
         ZGfFznAdjiAvF0CVggiuC7+V/mgZ41yn8A3VE=
Subject: [kernel] Question about 2.6.28 kernel
From: Alex <eosyop@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 18:11:24 +0100
Message-Id: <1233594684.3018.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I'm currently thinking of ways to hook system calls (PoC) in the linux
kernel 2.6.28. Based on a simple rootkit, which can be executed on the
2.6.23, i got an "oops.. unable to handle kernel paging request at
0x...", when i run it on a new kernel. Can anyone help me finding what
protection was added to prevent writings on kernel memory ? 

Thanks for your help.

Alex


