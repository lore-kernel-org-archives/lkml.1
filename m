Return-Path: <linux-kernel-owner+w=401wt.eu-S965393AbXCAQz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393AbXCAQz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXCAQz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:55:56 -0500
Received: from web63210.mail.re1.yahoo.com ([69.147.97.20]:38969 "HELO
	web63210.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965382AbXCAQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:55:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RqQjUX8eNaI3bVnv4d1ft1jsTXjWoA+mqWMtAhlY+oFU0c6ZG5ysjNRIG+2aY0tECmHgDsCyi00UT4NIkE8D3wpxzYm6RBKsiSFtPlD2KhHQA3TvZDmI2lRXiHAEi/yS/rNe7jhVVm8IDuyiRm3gb2ikNvGw5zgh1J8ThsEOpmQ=  ;
Message-ID: <20070301165554.9226.qmail@web63210.mail.re1.yahoo.com>
Date: Thu, 1 Mar 2007 08:55:54 -0800 (PST)
From: "Brandon W. Howard" <brandon_waldgrave@yahoo.com>
Subject: Re: First desktop motherboard supported by LinuxBIOS: GIGABYTE M57SLI-S4
To: James Simmons <jsimmons@infradead.org>
Cc: linux-kernel@vger.kernel.org, linuxbios@linuxbios.org
In-Reply-To: <Pine.LNX.4.64.0702281650140.14127@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- James Simmons <jsimmons@infradead.org> wrote:
> --- Brandon W. Howard <brandon_waldgrave@yahoo.com> wrote:
> > Hi,
> > 
> > The GIGABYTE M57SLI-S4 [1] is the first-ever desktop motherboard
> > supported by a Free & Open Source BIOS, thanks to AMD engineer
> > Yinghai
> > Lu who released GPL-licensed code last month. This
state-of-the-art
> > motherboard is based on the NVIDIA nForce 570 SLI chipset and
AMD's
> > latest Socket AM2. It contains tons of advanced features such as:
> > 
> > Support for AMD Athlon 64 X2, Athlon 64 FX and Athlon 64
processors
> > 2X PCI Express x16 slots
> > 3X PCI Express x1 slots
> > 2X PCI slots
> > 3X 1394a (FireWire) ports
> > 10X USB 2.0
> > 16GB maximum memory
> > SATA RAID
> > 6X SATA 3Gb/s slots.
> > 
> > This motherboard can be obtained today from many retail and online
> > stores [2] and the source code for the BIOS can be downloaded from
> > the
> > LinuxBIOS SVN server [3]. 
> > 
> > This is a huge victory in the quest for a completely Free & Open
> > Source general-purpose computer that enables users to have full
> > control over their own hardware. The Free Software Foundation has
> > made
> > the campaign for a Free BIOS a top priority because it is a key
> > component in the software stack of personal computers [4]. The
need
> > for a Free BIOS is even more pressing since DRM and Treacherous
> > Computing have found their way into some proprietary BIOSes and 
EFI.
> > From a practical perspective, LinuxBIOS removes the need for ugly
> > hacks and workarounds in the kernel that compensate for buggy 
BIOSes
> > –
> > we can now fix the BIOS ourselves.
> > 
> > I encourage everyone upgrading their desktop computers to consider
> > getting this motherboard or another one that is supported by
> > LinuxBIOS.
> > 
> > -Brandon
> > [1]
> > 
http://www.gigabyte.com.tw/Products/Motherboard/Products_Overview.aspx?ProductID=2287
> > [2] http://www.newegg.com/Product/Product.asp?Item=N82E16813128014

> > [3] http://linuxbios.org/Download_LinuxBIOS
> > [4] http://www.fsf.org/campaigns/free-bios.html
> 
> Quick question. Can this board initialize more than one graphics
> card?

The motherboard has plenty of expansion slots and is SLI-enabled, so
the hardware should support multiple graphics cards. I personally
haven’t tried this, but perhaps someone on the LinuxBIOS mailinglist
(CC’ed) has had experience with such a setup.

BTW: An OpenGraphics card (http://OpenGraphics.org ,
http://TraversalTech.com) will be released pretty soon that will be
fully documented and that will come with an open-source VGA video
BIOS.

-Brandon


 
____________________________________________________________________________________
Looking for earth-friendly autos? 
Browse Top Cars by "Green Rating" at Yahoo! Autos' Green Center.
http://autos.yahoo.com/green_center/


 
____________________________________________________________________________________
8:00? 8:25? 8:40? Find a flick in no time 
with the Yahoo! Search movie showtime shortcut.
http://tools.search.yahoo.com/shortcuts/#news
