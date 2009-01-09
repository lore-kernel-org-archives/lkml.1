Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZAINPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZAINPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZAINPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:15:05 -0500
Received: from main.gmane.org ([80.91.229.2]:58130 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZAINPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:15:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: FPGA programming driver architecture
Date: Fri, 9 Jan 2009 12:24:08 +0000
Message-ID: <88sj36-s3t.ln1@woodchuck.wormnet.eu>
References: <20081212150314.6ea24996.hugo@hugovil.com> <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com> <c384c5ea0901081447i5ad807b3yb0ec3adebeaa46a0@mail.gmail.com> <200901082357.24432.florian@openwrt.org> <c384c5ea0901081507v5d186eai5ec71d56b4c7a972@mail.gmail.com> <4966C125.10604@duaneellis.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.2-20070201 ("Dalaruan") (UNIX) (Linux/2.6.24-etchnhalf.1-sparc64 (sparc64))
Cc: linux-embedded@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duane Ellis <duane@duaneellis.com> wrote:
> >> [various FPGA config methods]
> 
> Don't forget JTAG, and playing back an SVF files, or BIT files.
> 
On the board we have, the FPGA is programmable over JTAG which is 
conveniently strapped to the GPIO pins of the CPU.

http://www.embeddedarm.com/products/board-detail.php?product=TS-7800

Cheers

Alex

-- 
Alexander Clouter
.sigmonster says: This screen intentionally left blank.

