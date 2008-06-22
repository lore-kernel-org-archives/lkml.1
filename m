Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYFVSok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYFVSok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYFVSoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:44:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:51926 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYFVSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:44:16 -0400
Date: Sun, 22 Jun 2008 11:39:32 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: (Resend of 23/70 plus reply [PATCH 00/70] tty updates proposed
	for 2.6.27)
Message-ID: <20080622183932.GA18502@kroah.com>
References: <20080620195406.1479.12620.stgit@localhost.localdomain> <20080621090910.GA12516@kroah.com> <20080621111709.7e8f7d44@lxorguk.ukuu.org.uk> <20080621111936.GB27069@cs181133002.pp.htv.fi> <20080622180756.75a54ff4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622180756.75a54ff4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 06:07:56PM +0100, Alan Cox wrote:
> > The USB_SERIAL_TI_FIRMWARE bits don't seem to belong here?
> 
> They seem to have gotten merged together by accident - shouldn't do any
> harm and both want doing. I can take a look at splitting it if Greg
> wants ?

I'll look at them on Monday when I'm going through applying the series
and see if it really matters or not :)

thanks,

greg k-h
