Return-Path: <linux-kernel-owner+w=401wt.eu-S935293AbZLGPPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935293AbZLGPPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935282AbZLGPPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:15:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935279AbZLGPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:15:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: What's in asm-generic.git
Date: Mon, 7 Dec 2009 16:14:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com>
In-Reply-To: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8bit
Message-Id: <200912071614.46166.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+xUjCFyarnvhZdgjVbPU02gCST/nRlxCAGUUa
 B5Xi5Q9ASxxObeKBWlwxqLa1ihOSa/K0iXOVtVDkFKjOZo4OQG
 OQBqWaFyWi7SjmhbNq5kg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, liqin.chen@sunplusct.com wrote:
> Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-12-04 03:14:08:
> 
> Maybe you can add a __NR_set_thread_area define in asm-generic/unsitd.h
> for tls used.

Yes, good point. I'll update the syscall list with this, and also check if more
syscalls have been addded.

	Arnd <><
