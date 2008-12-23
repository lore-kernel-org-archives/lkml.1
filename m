Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYLWEt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYLWEt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYLWEtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:49:47 -0500
Received: from kroah.org ([198.145.64.141]:44951 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754833AbYLWEtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:49:46 -0500
Date: Mon, 22 Dec 2008 20:37:14 -0800
From: Greg KH <greg@kroah.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: cannot reliably detect USB device
Message-ID: <20081223043714.GH1928@kroah.com>
References: <20081222084249.GA5845@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222084249.GA5845@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 04:42:49PM +0800, Wu Fengguang wrote:
> Hi Greg,
> 
> I have a pl2303 USB-RS232 converter that cannot be reliably detected.

Faulty hardware?  Flaky cables?  Bad connections?  If this is
reproducable for the same device on multiple machines, I'd just go buy a
new device :)

Other than that, sorry, I don't have any ideas.

greg k-h
