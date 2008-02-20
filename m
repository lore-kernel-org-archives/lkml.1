Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbYBTT3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbYBTT3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYBTT3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:29:44 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56741 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756482AbYBTT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:29:42 -0500
Date: Wed, 20 Feb 2008 14:29:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Buehler <abuehler.kernel@gmail.com>
cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly
 resolved
In-Reply-To: <47BC7101.4060501@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0802201428390.7056-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Andrew Buehler wrote:

> In other words: I don't think that's likely to be practical in the
> present instance. If you have reason to believe otherwise (past positive
> experience with Novell, for instance), I'd be glad to hear it.

Greg KH may be able to help in that respect.

> Is there any place (aside from maybe the kernel changelog, which
> contains a whole lot - if not several lots - of unrelated information)
> where I could find a list of config-symbol name additions, changes,
> deletions and meaning changes by version or by date? That would at least
> let me build a mapping between the symbols in the older config and the
> ones in the new one, which is about where I would have to start.

Not as far as I know.

Alan Stern

