Return-Path: <linux-kernel-owner+w=401wt.eu-S932757AbXA1T0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbXA1T0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbXA1T0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:26:24 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59034 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757AbXA1T0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:26:23 -0500
Date: Sun, 28 Jan 2007 11:22:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: akpm@osdl.org, dsd@gentoo.org, joerg@hydrops.han.de, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 7891] New: vdso page is no longer mapped for
Message-Id: <20070128112203.ffa8e695.randy.dunlap@oracle.com>
In-Reply-To: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com>
References: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 15:01:51 -0500 Parag Warudkar wrote:

> Here is a patch that does what Andrew Morton suggested (plus some more
> as explained below) .
> Patch inline below and also attached in case there is whitespace
> damage. Compile tested on i386 with make defconfig; make. If anyone
> can test on other arches and provide feedback that'd be great.

Please use tabs instead of spaces for indentation/alignment.
This applies to all of the Kconfig file changes and to
arch/x86_64/ia32/ia32_aout.c and fs/binfmt_aout.c.
The patch also contains (new) trailing whitespace.

---
~Randy
