Return-Path: <linux-kernel-owner+w=401wt.eu-S965442AbXCARbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965442AbXCARbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965449AbXCARbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:31:36 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:32914 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965442AbXCARbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:31:35 -0500
From: Marcel Siegert <mws@linuxtv.org>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] 2.6.21-rc1-git2 is incompilable
Date: Thu, 1 Mar 2007 18:31:25 +0100
User-Agent: KMail/1.9.6
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>, torvalds@linux-foundation.org,
       Slaby <jirislaby@gmail.com>, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, bunk@stusta.de,
       Stephane Eranian <eranian@hpl.hp.com>, akpm@linux-foundation.org
References: <20070301143407.29950@gmx.net>
In-Reply-To: <20070301143407.29950@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703011831.26520.mws@linuxtv.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007, Uwe Bugla wrote:
> Hi folks,
> trying to compile kernel 2.6.21-rc1-git2 is impossible. The broken module where the compiler gives up is /arch/i386/kernel/io_apic.c.
> 
> Regards
> 
> Uwe
> 
> P. S.: Wouldn't it be a good idea to test at least error-free compilation before stuff like this is being published?
> 

hi uwe,

according to kernel.org 
2.6.21-rc2-git1 is an actual snapshot

but, those are iirc auto generated. thus not being able to compile can happen.
it also depends on your special .config

best regards
marcel

p.s. wouldn't it be a good idea to check your mail recipients instead of sending mails to e.g. linux-dvb that do 
      have no use with fixes of floppy drivers and or compile status in io_apic? :)

dont take it too hard man...
