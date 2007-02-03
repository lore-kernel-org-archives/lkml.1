Return-Path: <linux-kernel-owner+w=401wt.eu-S1946162AbXBCAZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946162AbXBCAZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946166AbXBCAZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:25:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46399 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946162AbXBCAZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:25:51 -0500
Date: Fri, 2 Feb 2007 16:25:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Nigel Kirkland <nigel.kirkland@qlogic.com>
Subject: Re: [BUG] Unable to handle kernel NULL pointer
 dereference...as_move_to_dispatch+0x11/0x135
Message-Id: <20070202162541.20e1e930.akpm@linux-foundation.org>
In-Reply-To: <20070202205630.GI3737@andrew-vasquezs-computer.local>
References: <20070122183510.GA19905@andrew-vasquezs-computer.local>
	<20070201232302.905962b6.akpm@linux-foundation.org>
	<20070202205630.GI3737@andrew-vasquezs-computer.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 12:56:30 -0800
Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:

> > >         dt of=/dev/raw/raw1 procs=8 oncerr=abort bs=16k disable=stats limit=2m passes=1000000 pattern=iot dlimit=2048

What is this mysterious dt command, btw?
