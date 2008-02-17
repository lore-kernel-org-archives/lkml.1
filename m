Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYBQFrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYBQFrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYBQFrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:47:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbYBQFrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:47:07 -0500
Date: Sat, 16 Feb 2008 21:46:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc2-mm1 (build failure)
Message-Id: <20080216214627.e8248706.akpm@linux-foundation.org>
In-Reply-To: <20080216213225.f5f71c35.randy.dunlap@oracle.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216213225.f5f71c35.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 21:32:25 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> When SMP=n, x86_64 build gets:
> 
> arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> (.text+0xfd7f): undefined reference to `setup_trampoline'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 

Thanks.  Say hello to Pavel.
