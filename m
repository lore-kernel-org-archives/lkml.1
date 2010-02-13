Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0BMOSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 09:18:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42068 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab0BMOSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 09:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZQoRFf3Ud7Cl697O8kFJlVmGwLna+Rhiv6xsyo9ZPm2Fy1s2Mb9lt2ZNA4Vew9ebjM
         vjuGgF9ND7M1I/YbPdh4K9S/UovEhcc/zO0/B7Iwib9WEEKtbtlZRrnpFdAI/w6zd9l5
         O9FDlndxr5NJYVzMsxtvwRNBDK9uYAd/sMi4k=
Message-ID: <4B76B341.7010801@gmail.com>
Date: Sat, 13 Feb 2010 15:12:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.3 Thunderbird/3.0.1
MIME-Version: 1.0
To: Gordon Mitchell <gordon@dumgoyne.me.uk>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: Apply kernel coding style to source
 file r8180_93cx6.c This is a patch to the r8180_93cx6.c source file to correct
 all kernel coding style errors and warnings flagged by checkpatch.pl Signed-off-by:
 Gordon Mitchell <gordon@dumgoyne.me.uk>
References: <1266062646-6584-1-git-send-email-gordon@dumgoyne.me.uk>
In-Reply-To: <1266062646-6584-1-git-send-email-gordon@dumgoyne.me.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like something mangled headers, so that the changelog ended up in
Subject.

-- 
js
