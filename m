Return-Path: <linux-kernel-owner+w=401wt.eu-S965693AbXDCRUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbXDCRUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965934AbXDCRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:20:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36274 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965693AbXDCRUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:20:03 -0400
Date: Tue, 3 Apr 2007 18:22:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403182241.4b9abab6@the-village.bc.nu>
In-Reply-To: <46128C1B.1090900@redhat.com>
References: <461286D6.2040407@redhat.com>
	<p73abxpz5u1.fsf@bingen.suse.de>
	<46128C1B.1090900@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> benefit for the common use cases.  But as it is, the number of
> processors is not necessarily constant over the lifetime of a process.
> The machine architecture is.

Not once you have migration capable virtualisation it isnt.
