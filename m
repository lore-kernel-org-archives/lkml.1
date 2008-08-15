Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYHOCVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYHOCVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHOCVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:17420 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYHOCVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=naJRY7+ZeOeO1erGzyLl/3x9un0REDLYnEmcZvYs4cHDpBM6SS7bUE+css0KJWc+IM
         SaAGfMXm0/fVvaloGBRpo9EVcns+npkil4CYVeCWPlVeOwRM/gA0OvcRQDBBofU0UZAU
         +12Ufiteo0E/s1yvHparuYloGjziz/nesLTSQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
Date: Thu, 14 Aug 2008 19:20:25 -0700
Message-Id: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	fix the 32bit with bigsmp
	fix 64 bit with irq migration
	ordering functions in io_apic_xx.c


to do:
    merge io_apic_xx.c

Thanks

Yinghai Lu

