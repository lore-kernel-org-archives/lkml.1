Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZAVRam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZAVRam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZAVRaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:30:35 -0500
Received: from mail.openmoko.org ([88.198.124.205]:45660 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZAVRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:30:34 -0500
Date: Thu, 22 Jan 2009 23:00:21 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #587 for v2.6.29-rc2-13-gf3b8436
	:_set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
Message-ID: <20090122173020.GI3171@fedora.yogi>
References: <200901221812.20702.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901221812.20702.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 06:12:16PM +0100, Toralf Förster wrote:
> 
> -- 
> MfG/Sincerely
> 
> Toralf Förster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
> 

Content-Description: Toralf Förster <tfoerste@n22.n22_domain>: build issue #587 for v2.6.29-rc2-13-gf3b8436 :
> Date: Thu, 22 Jan 2009 18:10:21 +0100
> From: Toralf F�rster <tfoerste@n22.n22_domain>
> To: tfoerste@n22.n22_domain
> Subject: build issue #587 for v2.6.29-rc2-13-gf3b8436 :
> 
> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...

Hi,

This is known for more than two weeks. Fixes in various forms have been
sent on this list, but somehow it isn't making it to the destination..

Stephen has asked Linus to pull Samuel's tree (which has the fix). Let's
hope Linus pulls it soon..


Cheers,
Balaji
