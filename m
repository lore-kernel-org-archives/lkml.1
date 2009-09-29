Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZI2RUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZI2RUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZI2RUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:20:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:47338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZI2RUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:20:12 -0400
Date: Tue, 29 Sep 2009 19:19:51 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Shane Wang <shane.wang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20090929191951.18315e94@infradead.org>
In-Reply-To: <20090929171318.GC14405@elf.ucw.cz>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com>
	<200909262344.21257.rjw@sisk.pl>
	<20090928210252.GD1960@elf.ucw.cz>
	<200909282307.56190.rjw@sisk.pl>
	<4AC1267D.6020405@zytor.com>
	<20090928211745.GA2119@elf.ucw.cz>
	<4AC1AA61.8070408@intel.com>
	<20090929171318.GC14405@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 19:13:18 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Ok, and what prevents me from commenting out the MAC checking code?
> 

because the bios verified some code that verified the kernel which
includes the MAC checking code .. as part of returning from S3 ?

> 							

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
