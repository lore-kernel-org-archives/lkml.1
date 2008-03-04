Return-Path: <linux-kernel-owner+w=401wt.eu-S932717AbYCDUZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbYCDUZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933849AbYCDUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:24:57 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:31179 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844AbYCDUYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:24:55 -0500
Date: Tue, 4 Mar 2008 12:24:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: 2.6.25-rc3-mm1 (wakeup)
Message-Id: <20080304122414.f4b7e7f7.randy.dunlap@oracle.com>
In-Reply-To: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/

Both x86_64 and i386 builds throw these messages at me:

  LD      arch/x86/kernel/acpi/realmode/wakeup.elf
ld: warning: dot moved backwards before `.text'
ld: warning: dot moved backwards before `.text'
ld: warning: dot moved backwards before `.text'
  OBJCOPY arch/x86/kernel/acpi/realmode/wakeup.bin


---
~Randy
