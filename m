Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYBPKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYBPKB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYBPKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:01:50 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60457 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752703AbYBPKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:01:49 -0500
Date: Sat, 16 Feb 2008 09:53:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Omar Kilani" <omar.kilani@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: aacraid: Host adapter reset request. SCSI hang ?
Message-ID: <20080216095347.3293e272@core>
In-Reply-To: <f0cc3e3e0802152238t59498e3bv229d02ee3d96cea7@mail.gmail.com>
References: <f0cc3e3e0802152238t59498e3bv229d02ee3d96cea7@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 17:38:13 +1100
"Omar Kilani" <omar.kilani@gmail.com> wrote:

> Hi there,
> 
> We're having issues with our Adaptec RAID controller and I was
> wondering if anyone would be able to advise on how to go about
> resolving them. :)
> 
> The system:
> 
> RHEL 5.1 x86_64
> Kernel 2.6.18-53.1.4.el5
> aacraid 1.1-5[2437]-mh4 (The default module shipped with the RHEL kernel)

For vendor enterprise kernels you really need to go and ask the vendor or
vendor list, they diverge from the base kernels quite a bit (as they are
full of backports not updates) and the base code is [by Linux standards]
very old.

Alan
