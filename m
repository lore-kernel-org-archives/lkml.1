Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbYHEJ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbYHEJ1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbYHEJ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:26:52 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:53193 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757669AbYHEJ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:26:50 -0400
Message-ID: <48981CD5.5090106@davidnewall.com>
Date: Tue, 05 Aug 2008 18:56:45 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: David Wilson <mcs6502@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: What is the best way to identify a new x86 processor that does
 not implement the CPUID instruction?
References: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
In-Reply-To: <3666888f0808050008h38e11737k8e6cb9c4c85aa457@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wilson wrote:
> I recently bought a Norhtec MicroClient JrSX which uses the Vortex86sx
> System on Chip processor (see http://vortex86sx.com/ for more
> details). This is identified as a Cyrix 486SLC by the Linux kernel due
> to the lack of a CPUID instruction.

Consider creating a new boot-time parameter to identify it.
