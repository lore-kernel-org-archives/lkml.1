Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZKQRCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZKQRCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZKQRCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:02:45 -0500
Received: from xenotime.net ([72.52.64.118]:44772 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752161AbZKQRCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:02:44 -0500
Date: Tue, 17 Nov 2009 09:02:48 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 17 (exofs)
Message-Id: <20091117090248.bb66c230.rdunlap@xenotime.net>
In-Reply-To: <20091117195309.6cc3ead0.sfr@canb.auug.org.au>
References: <20091117195309.6cc3ead0.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 19:53:09 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20091116:


on i386 (X86_32):

fs/built-in.o: In function `exofs_sbi_read':
(.text+0x592964): undefined reference to `__umoddi3'

---
~Randy
