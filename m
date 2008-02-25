Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYBYI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYBYI4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYBYI4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:56:06 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48213 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYBYI4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:56:05 -0500
Message-ID: <47C28347.7000705@keyaccess.nl>
Date: Mon, 25 Feb 2008 09:58:47 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ady Wicaksono <ady.wicaksono@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Patch kernel: I have 8 Gbytes RAM, but why I can only allocate
 2.8 Gbytes RAM for a single process?
References: <2743ae110802242344s4406cd5eq3c5e8d0a6e69101b@mail.gmail.com>
In-Reply-To: <2743ae110802242344s4406cd5eq3c5e8d0a6e69101b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-02-08 08:44, Ady Wicaksono wrote:

> I have 8 Gbytes RAM, but why I can allocate 2.8 Gbytes RAM for a single
> process? How to patch kernel so I have more than 2.8 Gbytes limitation?

[ ... ]

> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> lm constant_tsc pni monitor ds_cpl est cid xtpr

Run a 64-bit kernel and userspace. not a 32-bit.

Rene.
