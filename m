Return-Path: <linux-kernel-owner+w=401wt.eu-S2992764AbXDTJ3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992764AbXDTJ3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992773AbXDTJ3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:29:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992764AbXDTJ3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:29:01 -0400
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: roland <devzero@web.de>, linux-kernel@vger.kernel.org
Subject: Re: VMWare Workstation 6 for debugging Linux Kernel (!)
References: <03f401c782d4$95c323e0$eeeea8c0@aldipc>
	<1177058522.14404.132.camel@frg-rhel40-em64t-04>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Apr 2007 12:27:03 +0200
In-Reply-To: <1177058522.14404.132.camel@frg-rhel40-em64t-04>
Message-ID: <p73r6qf49zc.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel <xavier.bestel@free.fr> writes:

> On Fri, 2007-04-20 at 00:46 +0200, roland wrote:
> 
> > We just quietly added an exciting feature to Workstation 6.0. I believe it 
> > will make WS6 a great tool for Linux kernel development. You can now debug 
> > kernel of Linux VM with gdb running on the Host without changing anything in 
> > the Guest VM. No kdb, no recompiling and no need for second machine. All you 
> > need is a single line in VM's configuration file.
> 
> I think qemu has the exact same feature.

It doesn't seem to work for x86-64 there though.

AMD SimNow! and Virtutech Simics can do it too. But great the Vmware catches up.

-Andi
