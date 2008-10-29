Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYJ2VKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYJ2VKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYJ2VKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:10:07 -0400
Received: from main.gmane.org ([80.91.229.2]:39551 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbYJ2VKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:10:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Moritz Muehlenhoff <jmm@debian.org>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Date: Wed, 29 Oct 2008 19:57:19 +0100
Organization: Cocytus
Message-ID: <slrngghcgf.3do.jmm@inutil.org>
References: <20081028154918.GA5630@mediacenter>
 <20081028163456.GA4278@suse.de>
 <20081028103337.a021e85d.rdunlap@xenotime.net>
 <20081028181402.GB4873@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dslb-082-083-192-054.pools.arcor-ip.net
User-Agent: slrn/0.9.9 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Of course, if someone doesn't want their code in the staging tree, I
> will not add it, that's just being "nice".
>
> As for what I will not put into staging, right now I'm sticking with
> drivers only, no filesystems (people have asked already).  I don't think
> we have seen any drivers that I will not put into the staging tree yet.

Hi Greg,
Great effort with staging, thanks a lot!

I've had a look at the out-of-tree kernel drivers currently present
in Debian, maybe you want to merge some into staging. The Debian
overview pages contain download links (the orig.tar.gz files):

Acer hotkey driver:
http://packages.qa.debian.org/a/acerhk.html
http://www.cakey.de/acerhk/

Synaptics cPad:
http://packages.qa.debian.org/c/cpad-kernel.html
http://www.janerob.com/rob/ts5100/cPad/index.shtml

3Dfx driver:
http://packages.qa.debian.org/d/device3dfx.html
http://glide.sourceforge.net/

et131x Ethernet Controller:
http://packages.qa.debian.org/e/et131x.html
http://sourceforge.net/projects/et131x/

GPIB (IEEE 488) drivers:
http://packages.qa.debian.org/g/gpib.html
http://linux-gpib.sourceforge.net/

LEDs driver of PCEngines ALIX 2/3 boards:
http://packages.qa.debian.org/l/leds-alix.html
https://dev.openwrt.org/

Kernel driver for the back-end scaler on Matrox cards:
http://packages.qa.debian.org/m/mga-vid.html
http://attila.kinali.ch/mga/

ov51x-jpeg driver:
http://packages.qa.debian.org/o/ov51x-jpeg.html
http://www.rastageeks.org/ov51x-jpeg/index.php/Main_Page

tp_smapi kernel modules:
http://packages.qa.debian.org/t/tp-smapi.html
http://tpctl.sourceforge.net/

Voicetronix telephony hardware:
http://packages.qa.debian.org/v/vpb-driver.html
http://www.voicetronix.com.au/

Cheers,
        Moritz

