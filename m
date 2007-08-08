Return-Path: <linux-kernel-owner+w=401wt.eu-S936411AbXHHSa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936411AbXHHSa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760165AbXHHSaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:30:15 -0400
Received: from mail.tpi.com ([198.107.51.143]:2819 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829AbXHHSaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:30:14 -0400
Message-ID: <46BA0BB4.50607@canonical.com>
Date: Wed, 08 Aug 2007 12:30:12 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Chuck Ebbert <cebbert@redhat.com>,
       linux-acpi@vger.kernel.org, loic.grenie@gmail.com
Subject: Re: ACPI Regression on Dell E1501
References: <467AE7E1.4050805@canonical.com>  <467AF204.3060805@redhat.com> <1182462902.3316.105.camel@chaos> <467AF647.4030100@canonical.com>
In-Reply-To: <467AF647.4030100@canonical.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

See this topic for a solution:

http://lkml.org/lkml/2007/8/8/251
Re: [PATCH] drop unneeded variable in amd_apic_timer_broken
-- 
Tim Gardner tim.gardner@ubuntu.com
