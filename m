Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbXIRB7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbXIRB7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 21:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbXIRB7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 21:59:37 -0400
Received: from uni21mr.unity.ncsu.edu ([152.1.2.137]:50005 "EHLO
	uni21mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbXIRB7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 21:59:36 -0400
Message-ID: <46EF3104.8080805@ncsu.edu>
Date: Mon, 17 Sep 2007 21:59:32 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG:] forcedeth: MCP55 not allowing DHCP
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070912192854.GA32610@askeshav-devel.jf.intel.com> <18150.61732.490669.269794@cargo.ozlabs.ibm.com> <20070912215523.GA510@askeshav-devel.jf.intel.com> <46E7111B.2050303@ncsu.edu>
In-Reply-To: <46E7111B.2050303@ncsu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.313940, Antispam-Data: 2007.9.17.183226
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Dahlin wrote:
> I have an Asus Striker Extreme motherboard with two built in MCP55 
> GigE interfaces. When I build with the original Fedora 7 release 
> kernel ( 
> ftp://ftp.belnet.be/linux/fedora/linux/releases/7/Fedora/i386/os/Fedora/kernel-2.6.21-1.3194.fc7.i686.rpm 
> ) everything works fine. However, when I boot with any updated kernels 
> or any other kernel (have tried building from several points in the 
> linus git tree between 2.6.20 and .23-rc3, and 2.6.21.2 in -stable) I 
> cannot get an IP address via dhcp. There is no error in dmesg. The 
> card shows a link and otherwise appears to be working, but it is as if 
> the dhcp server has been removed from the network.
>
> On a running system there is no indication that this is a kernel bug 
> at all, however by varying only the kernel the bug appears and 
> disappears. I've run all these tests repeatedly with no intervening 
> updates of any other packages.
>
> As I said I attempted to build 2.6.21.2 ( the point of divergence 
> between the Fedora kernel in question and -stable ) and still the card 
> did not work. I will next attempt to manually build the rpm for the 
> release kernel. If this works I will try experimenting with the 
> included patches to narrow it down, but at this point I'm at a 
> complete loss.
>
> -Casey Dahlin
>

Is there any feedback to be had on this? I've gotten no reply whatsoever 
from several sources now.
