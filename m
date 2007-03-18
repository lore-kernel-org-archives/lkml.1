Return-Path: <linux-kernel-owner+w=401wt.eu-S1751260AbXCRVLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbXCRVLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXCRVLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:11:00 -0400
Received: from charon.hkfree.org ([89.248.240.1]:44604 "EHLO charon.hkfree.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXCRVLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:11:00 -0400
Message-ID: <45FDAADF.7060808@assembler.cz>
Date: Sun, 18 Mar 2007 22:10:55 +0100
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Nicolas Boichat <nicolas@boichat.ch>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       debian-user@lists.debian.org, bytes@linuxgazette.net
Subject: Re: Intel Core Duo/Solo Temperature Monitoring Working On Intel DG965
 Motherboard
References: <Pine.LNX.4.64.0703100707320.3807@p34.internal.lan> <45F92D99.1020007@boichat.ch>
In-Reply-To: <45F92D99.1020007@boichat.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
> I'm just wondering if it is right to export the functions msr_read and
> msr_write from arch/i386/kernel/msr.c, or if it would be better to put
> these functions in arch/i386/lib/msr-on-cpu.c with rdmsr_on_cpu and
> wrmsr_on_cpu.

I'm fixing this, please stay tuned. I will CC you in new thread, when looking
for testers. The driver is reviewed, this is the last issue.

Rudolf
