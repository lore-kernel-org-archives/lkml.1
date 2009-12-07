Return-Path: <linux-kernel-owner+w=401wt.eu-S935413AbZLGQtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935413AbZLGQtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbZLGQtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:49:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323AbZLGQtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:49:08 -0500
Date: Mon, 7 Dec 2009 08:48:16 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Libin Yang <libin.yang@amd.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [041/119] USB: ohci: quirk AMD prefetch for
 USB 1.1	ISO transfer
Message-ID: <20091207164816.GA31258@suse.de>
References: <20091206235936.208334321@mini.kroah.org>
 <20091207000646.961519997@mini.kroah.org>
 <4B1D277E.207@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D277E.207@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 05:04:14PM +0100, Stefan Bader wrote:
> Just to verify this, the patch also adds a call to quirk_amd_pll
> but from the description it is not clear to me this is intended.

Why not?
