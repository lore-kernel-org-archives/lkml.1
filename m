Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbXGLHjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbXGLHjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbXGLHjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:39:00 -0400
Received: from mx0.towertech.it ([213.215.222.73]:35483 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755647AbXGLHjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:39:00 -0400
Date: Thu, 12 Jul 2007 09:37:57 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Alex Maclean <monkeh@monkeh.net>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Tim Gardner <tim.gardner@canonical.com>
Subject: Re: acpi regression on some laptops
Message-ID: <20070712093757.24cb70ae@i1501.lan.towertech.it>
In-Reply-To: <46957CAC.8060308@monkeh.net>
References: <20070710160056.443ae9ae@i1501.lan.towertech.it>
	<46952CC5.6050800@redhat.com>
	<20070712000124.22d0c3a7@i1501.lan.towertech.it>
	<46955F4D.3090206@monkeh.net>
	<20070712020944.446f3828@i1501.lan.towertech.it>
	<46957CAC.8060308@monkeh.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 00:58:20 +0000
Alex Maclean <monkeh@monkeh.net> wrote:

> >  hw is a Dell Inspiron 1501, AMD Turion TL52 based.
> >  drop me a note if you need dmesg or other info.

> > 
> >  eax in    eax      ebx      ecx      edx
> > 00000000 00000001 68747541 444d4163 69746e65
> > 00000001 00040f82 01020800 00002001 178bfbff
> > 
> 
> What chipset is it? I'm going to guess at nVidia MCP51, in which case.. 
> That's the third time that's worked on the MCP51.

 amd sb600/ati rs480.



-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

