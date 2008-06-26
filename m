Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYFZBEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYFZBEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYFZBBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:44 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:23642 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYFZBBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=oElD3zNcDOj7Lv3/ieTaZHsRdg8A/aQDEBdknF1nE6i8H/CpFqOPZno5MxHIcZelAz
         gFoEYGhr9Uxcuq14sgx4AoAL4J1HVASB7FBXiD909LWz781yBYruJ7dHcgNJA/15ONzh
         LByJyIv+rYyzWlqOu9ZYI1BSUu7eE2rzM3LWg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/16] x86: space to tab in setup_arch
Date: Wed, 25 Jun 2008 17:53:22 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251753.22281.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -557,10 +557,10 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
-        /*
-         * Parse SRAT to discover nodes.
-         */
-        acpi_numa_init();
+	/*
+	 * Parse SRAT to discover nodes.
+	 */
+	acpi_numa_init();
 #endif
 
 	initmem_init(0, max_pfn);
