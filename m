Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXFRWfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXFRWfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764537AbXFRWfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:35:05 -0400
Received: from mail.samba.org ([66.70.73.150]:50355 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763874AbXFRWfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:35:02 -0400
Date: Mon, 18 Jun 2007 15:34:25 -0700
From: Jeremy Allison <jra@samba.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       alan <alan@clueserver.org>, Bodo Eggert <7eggert@gmx.de>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618223425.GL1152@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org> <20070618222656.GB25089@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618222656.GB25089@lazybastard.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 12:26:57AM +0200, Jörn Engel wrote:
> 
> Pointless here means that _I_ don't see the point.  Maybe there are
> valid uses for extended attributes.  If there are, noone has explained
> them to me yet.

Samba uses them to store DOS'ism's that you don't want in your
POSIX filesystem.

Jeremy.
