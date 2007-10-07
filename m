Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbXJGUgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbXJGUgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 16:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXJGUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 16:36:18 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54015 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbXJGUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:36:17 -0400
Date: Sun, 7 Oct 2007 22:50:24 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: tty UI (Re: [PATCH 0/2] Colored kernel output (run2))
Message-ID: <20071007205024.GT22435@flower.upol.cz>
References: <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <Pine.LNX.4.64.0710072123460.16301@fbirervta.pbzchgretzou.qr> <47093AFB.8000805@keyaccess.nl> <Pine.LNX.4.64.0710072203570.16301@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710072203570.16301@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 10:04:44PM +0200, Jan Engelhardt wrote:
> 
> On Oct 7 2007 22:00, Rene Herman wrote:
> > On 10/07/2007 09:56 PM, Jan Engelhardt wrote:
> >
> >> Some is good, as long as it is not excessive. While I could imagine that
> >> Knoppix will abuse the feature and use vt.printk_color=9,9,9,9,11,10,12, this
> >> is not what serious people would do.
> >> 
> >> [1] http://tinyurl.com/yr9zgq
> >> [2] http://tinyurl.com/234ba3
> >
> > Given this discussion, I find it really appropriate that you are posting
> > _graphics_ of your text screens :-)
> 
> I can give you a VCSA file (as produced by /dev/vcsa1) if you like,
> complete with VCSA reader.

In fact mc config (ini) section is a better way.

I use default blue (which is very annoying) for root user, to be aware of
possible results. Otherwise i use black background:

[Colors]
color_terminals=linux,xterm
base_color=normal=lightgray,black:marked=magenta,black:executable=green,black:directory=lightgray,black:editnormal=green,black:editbold=red,black

The most exiting event recently was, that `lynx` in debian got updated, so
it displays much more colors for HTML formatting now. I'm happy.
____
