Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbXLRQfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbXLRQfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 11:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXLRQfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 11:35:04 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37397 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbXLRQfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 11:35:03 -0500
Date: Tue, 18 Dec 2007 08:34:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: shashi59 <sasikumar.periyasamy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory Read Error
Message-Id: <20071218083447.ac2eabcd.randy.dunlap@oracle.com>
In-Reply-To: <14390531.post@talk.nabble.com>
References: <14390531.post@talk.nabble.com>
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

On Tue, 18 Dec 2007 02:13:30 -0800 (PST) shashi59 wrote:

> 
> I am newbie for Linux Kernel.How can I read the memory area like the range
> between ffff0000 to ffffffff.Directly i read that area it shows some error
> like this "unable to handle kernel paging request at virtual address
> ffff0000". So,I don't know, how to solve this error .Please anyone help
> me....

"Unable to handle kernel paging request at virtual address ffff...."
is almost always indicative of a kernel bug and not a memory error.

Please gather bug reporting data and report it as described in the
file: REPORTING-BUGS in the kernel source tree's top-level directory.

However:  if the kernel is very old, the answer may be just to use a
newer kernel version.  Or if the kernel is a vendor-supported kernel
version, then that vendor is probably where the bug report should go.

---
~Randy
