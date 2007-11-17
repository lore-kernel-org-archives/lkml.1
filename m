Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbXKQTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbXKQTp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759402AbXKQTpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:45:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46901 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234AbXKQTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:45:15 -0500
Date: Sat, 17 Nov 2007 11:12:11 -0800
From: Greg KH <greg@kroah.com>
To: Javier Kohen <jkohen@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, stable@kernel.org
Subject: Re: [stable] Soft lockups since stable kernel upgrade to 2.6.23.8
Message-ID: <20071117191211.GA12757@kroah.com>
References: <1195323695.5240.16.camel@null.tough.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195323695.5240.16.camel@null.tough.com.ar>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 07:21:35PM +0100, Javier Kohen wrote:
> I upgraded today from 2.6.23 to 2.6.23.8 and started seeing a lot of
> these in the logs:

Can you see if the problem showed up in 2.6.23.2 or .3 to help narrow
this down?

thanks,

greg k-h
