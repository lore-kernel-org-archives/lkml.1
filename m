Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZDNE4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZDNE4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZDNE4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:56:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:37708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZDNE4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:56:05 -0400
Subject: Re: [PATCH] radeon_cp: use request_firmware
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: martin@valinux.com, gareth@valinux.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
In-Reply-To: <1239647163.18110.150.camel@deadeye.i.decadent.org.uk>
References: <1239640067.3237.4.camel@ht.satnam>
	 <1239647163.18110.150.camel@deadeye.i.decadent.org.uk>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 10:24:41 +0530
Message-Id: <1239684881.3033.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 19:26 +0100, Ben Hutchings wrote:
> Please use <ben@decadent.org.uk> for all mail related to my work on
> firmware separation, which has nothing to do with my employment.
> 
> On Mon, 2009-04-13 at 21:57 +0530, Jaswinder Singh Rajput wrote:
> > Moved datah before datal because datah is required before datal.
> > 
> > Firmware blob looks like this...
> > 	__be32 datah
> > 	__be32 datal
> > 
> > Thanks to Ben for help and testing.
> [...]
> 
> This is out of date as there are now an r600_microcode.h and r600_cp.c.
> My latest patch (not posted anywhere yet) is at
> <http://womble.decadent.org.uk/tmp/fw-patch/0003-radeon-Use-request_firmware.patch> (patches 0001-0003 should be applicable in order to drm-2.6/drm-linus).  But I don't have any R600/R700 hardware to test it on.
> 

I am very surprise you take my patches and post them without CC to me ?

Please use my signed-off in my patches in first place:

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Or prepare incremental patch to my patch.

Here are other stolen patches without CC and my Signed-off:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=06e1f9ffa023c030bc87491e75f625f5da4e7d97
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b775a750c3afacbfac884537d466d34d50b1023b

Why you do this ?

--
JSR

