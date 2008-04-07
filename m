Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYDGFm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYDGFm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbYDGFmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:42:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35364 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYDGFmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:42:47 -0400
Date: Sun, 6 Apr 2008 22:48:32 -0700
From: Greg KH <greg@kroah.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: power off USB port
Message-ID: <20080407054832.GA11216@kroah.com>
References: <1207477224.3785.10.camel@bip.parateam.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207477224.3785.10.camel@bip.parateam.prv>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 12:20:24PM +0200, Xavier Bestel wrote:
> Hi,
> 
> I'd like to power off some usb ports (to make ejected usb flash drives
> power off their little "don't remove me yet" led), but I can't find how
> to do it with a 2.6.24 kernel:
> - eject /dev/sd? doesn't work anymore
> - /sys/bus/usb/devices/*/power/state doesn't exist anymore
> - hub-ctrl-2.c [1] fails with a "Broken pipe" error
> 
> Does anyone know how to achieve that ?

You can not, sorry.  Please see the archives of this list, and the
linux-usb list for the many many many times this keeps coming up.

thanks,

greg k-h
