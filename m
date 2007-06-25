Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbXFYOFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbXFYOFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXFYOFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:05:10 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:56887 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbXFYOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:05:09 -0400
Date: Mon, 25 Jun 2007 16:05:07 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Tomasz =?iso-8859-2?Q?K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625140507.GC31762@boogie.lpds.sztaki.hu>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <20070625130147.GB31762@boogie.lpds.sztaki.hu> <Pine.BSO.4.63.0706251538060.25800@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSO.4.63.0706251538060.25800@rudy.mif.pg.gda.pl>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 03:41:44PM +0200, Tomasz K³oczko wrote:

> Sorry but skype does not for me after switching to ALSA (on skype cfg 
> level). Probably ALSA developers can explain why :>
> All above on fresh FC6 and 1.3.53 skype.

$ dpkg -l | grep skype
ii  skype                             1.4.0.74-1

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
