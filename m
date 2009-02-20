Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZBTN7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZBTN7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZBTN7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:59:35 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:40187 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbZBTN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:59:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4MAANGnknVcsfHPGdsb2JhbAAIiRqLKgEBAQE1Ab81hA8G
Message-ID: <499EB742.4050208@sundmangroup.com>
Date: Fri, 20 Feb 2009 14:59:30 +0100
From: Matias <linux@sundmangroup.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SMP Kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
When an SMP enabled kernel is booted on a Dual Core x86 machine ( Core 
0-1 ) I guess the Kernel is decompressed and started on core 0.
At some point in time the kernel becomes SMP aware and can then 
distribute threads on Cores 0 and 1.

Now, does the non-threaded part of the kernel with the scheduler 
continue to run solely on Core 0?

Cheers // Matias
