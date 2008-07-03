Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYGCTlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYGCTlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbYGCTlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:41:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYGCTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:41:08 -0400
Date: Thu, 3 Jul 2008 12:31:07 -0700
From: Greg KH <greg@kroah.com>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] edgeport: use request_firmware
Message-ID: <20080703193107.GA14194@kroah.com>
References: <1215085813.24938.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215085813.24938.5.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 05:20:13PM +0530, Jaswinder Singh wrote:
> Using HEX format.
> Versions are first record.
>     
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

This should go through David's tree, right?  If so, no objections from
me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


thanks,

greg k-h
