Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZAYUST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZAYUST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZAYUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:18:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55446 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133AbZAYUSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:18:10 -0500
Date: Sun, 25 Jan 2009 20:18:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Charles Landau <clandau@macslab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Gateway DX4720-03 apic problem
Message-ID: <20090125201825.0fbf1008@lxorguk.ukuu.org.uk>
In-Reply-To: <497CBF12.10202@macslab.com>
References: <497CBF12.10202@macslab.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2009 11:35:46 -0800
Charles Landau <clandau@macslab.com> wrote:

> I have a new Gateway DX4720-03 PC and have discovered that it won't 
> install Fedora 10 unless I give the kernel boot option "noapic" or 
> "nolapic".
> 
> This system's processor is the Intel Pentium Dual Core E5200.
> 
> It would seem that this is either a kernel bug to be fixed, or a 
> documentation bug so users of this machine know about the workaround. 
> I'll report the bug if someone will tell me how.

It should only be necessary if the system has BIOS problems. File a
report anyway and include the lspci -vvxxx and dmidecode data as
attached files
