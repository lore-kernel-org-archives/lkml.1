Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbXJ3Cbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbXJ3Cbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 22:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXJ3Cb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 22:31:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40591 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXJ3Cb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 22:31:27 -0400
Date: Mon, 29 Oct 2007 19:07:39 -0700
From: Greg KH <greg@kroah.com>
To: Marcin ?lusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usbserial.ko/option.ko on 2.6.23: Unable to handle kernel
	paging request && inconsistent lock state
Message-ID: <20071030020739.GA20046@kroah.com>
References: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 11:26:31PM +0100, Marcin ?lusarz wrote:
> Hi
> While fighting with Option Globesurfer ICON USB modem I got oops and
> lockdep warning:
> 
> (on rmmod option usbserial, not reproducible)

If you can reproduce this without the nvidia driver loaded, please let
me know.

thanks,

greg k-h
