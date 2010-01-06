Return-Path: <linux-kernel-owner+w=401wt.eu-S932386Ab0AFRFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0AFRFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367Ab0AFRFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:05:07 -0500
Received: from THUNK.ORG ([69.25.196.29]:45105 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab0AFRFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:05:06 -0500
Date: Wed, 6 Jan 2010 12:03:55 -0500
From: tytso@mit.edu
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] enhanced reimplemented of the kfifo API
Message-ID: <20100106170355.GB24604@thunk.org>
Mail-Followup-To: tytso@mit.edu, Stefani Seibold <stefani@seibold.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1262776358.29513.10.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262776358.29513.10.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 12:12:38PM +0100, Stefani Seibold wrote:
> - Smaller footprint

Have you measured how much smaller a full built kernel ends up being
with this patch?

> The patch-set is against linux 2.6.33-rc2. This code is ready to merge :-)
> Please do!

You weren't seriously suggesting merging such a large patch post -rc3,
were you?  I assume you were requesting this be queued up for the next
merge window, right?

						- Ted
