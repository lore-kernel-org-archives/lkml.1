Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbXFPT5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbXFPT5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 15:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbXFPT5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 15:57:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44365 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbXFPT5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 15:57:00 -0400
Date: Sat, 16 Jun 2007 12:57:38 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] make pci_ids lowercase hexa
Message-ID: <20070616195738.GB23443@kroah.com>
References: <116342983010020429@wsc.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <116342983010020429@wsc.cz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 05:44:52PM +0200, Jiri Slaby wrote:
> make pci_ids lowercase hexa

Why?  What good is this going to do in the long run?

Also, shouldn't you send pci specific patches like this to the pci
maintainer?  :)

thanks,

greg k-h
