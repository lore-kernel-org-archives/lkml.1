Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbXKZXav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbXKZXav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757937AbXKZXal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:30:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178AbXKZXak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:30:40 -0500
Date: Mon, 26 Nov 2007 15:28:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@elte.hu, riel@redhat.com, kamalesh@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
       tglx@linutronix.de, clameter@sgi.com
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Message-Id: <20071126152832.f6c808f3.akpm@linux-foundation.org>
In-Reply-To: <474B5349.2070500@gmail.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743CC0B.9000508@linux.vnet.ibm.com>
	<20071120221839.faab108e.akpm@linux-foundation.org>
	<20071126143943.0a01665b@cuia.boston.redhat.com>
	<20071126123319.7483e57f.akpm@linux-foundation.org>
	<20071126204540.GA19874@elte.hu>
	<474B43E1.9080407@gmail.com>
	<20071126141713.3dcd492b.akpm@linux-foundation.org>
	<474B5349.2070500@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 00:14:17 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/26/2007 11:17 PM, Andrew Morton wrote:
> >> Maybe if you can emit a broken-out with the fresh pull to test?
> > 
> > http://userweb.kernel.org/~akpm/mmotm/ is current.  But it probably won't
> > compile. 
> 
> Yes it did :). And it worked. Both in qemu and on my desktop...

boggle.  Let's slap 2.6.25 on it and take the rest of the year off.

> qemu output at:
> http://www.fi.muni.cz/~xslaby/sklad/qemu-output.txt

Thanks for testing.

