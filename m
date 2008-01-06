Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYAFUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYAFUQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYAFUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:16:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59276 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYAFUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:16:07 -0500
Date: Sun, 6 Jan 2008 20:15:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Berthold Cogel <cogel@uni-koeln.de>
Cc: linux-kernel@vger.kernel.org, nigel@nigel.suspend2.net, dtor@mail.ru,
       jikos@jikos.cz, akpm@linux-foundation.org,
       linux-usb-owner@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
Message-ID: <20080106201559.GU27894@ZenIV.linux.org.uk>
References: <477A93CD.9030707@rrz.uni-koeln.de> <20080105065233.GE27894@ZenIV.linux.org.uk> <47801D70.8020504@uni-koeln.de> <20080106001756.GP27894@ZenIV.linux.org.uk> <47812E5B.6080000@uni-koeln.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47812E5B.6080000@uni-koeln.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 08:39:07PM +0100, Berthold Cogel wrote:
> >>If I'm able to reproduce the oops with my patched kernel, I will gladly 
> >>follow your advice.
> >
> >AFAICS, lkml.org/lkml/2007/7/24/20 is the same patch...
> 
> Ok! It happened again....
> 
> I was able to reproduce the Oops twice. Once with my patched kernel
> (2.6.23.12 patched with tuxonice-3.0-rc3-for-2.6.23.9 on Debian
> stable/testing/unstable) and the second time with a vanilla 2.6.23.12
> kernel. So this isn't related to Tuxonice.

Apply the patch in aforementioned posting and see if it fixes the things?
