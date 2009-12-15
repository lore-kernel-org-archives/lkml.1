Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbZLOTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbZLOTnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZLOTnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:43:19 -0500
Received: from xenotime.net ([72.52.64.118]:42317 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759707AbZLOTnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:43:17 -0500
Date: Tue, 15 Dec 2009 11:43:26 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32 build problem on Mint 8 (kubuntu-9.10 i86-x64)
Message-Id: <20091215114326.90f66f16.rdunlap@xenotime.net>
In-Reply-To: <200912151426.26285.gene.heskett@verizon.net>
References: <200912151426.26285.gene.heskett@verizon.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 14:26:26 -0500 Gene Heskett wrote:

> Greetings;
> 
> I just tried to build 2.6.32 for for that Mint 8 install by using mc to copy 
> the src's over, then did a "chown -R gene:gene linux-*", cd'd into the tree 
> and typed 'make xconfig'  but it errors out, can't find the qt-mt stuff 
> installed on the *buntu's.
> 
> The  I tried a 'make menuconfig' which also quits quickly because it can't 
> find the ncurses stuff either.
> 
> At this point, maybe I should have tried as root rather than as a common 
> user, me, but I'm told its better not to build this stuff as root.
> 
> I took some pix, where should I post them?

Sounds like you should either install the needed packages or
take this up with Ubuntu.

---
~Randy
