Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbXFRWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbXFRWs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762815AbXFRWsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:48:19 -0400
Received: from mail.samba.org ([66.70.73.150]:51116 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762944AbXFRWsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:48:18 -0400
Date: Mon, 18 Jun 2007 15:48:15 -0700
From: Jeremy Allison <jra@samba.org>
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       alan <alan@clueserver.org>, Bodo Eggert <7eggert@gmx.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618224815.GM1152@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <8wsCC-3wf-21@gated-at.bofh.it> <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it> <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it> <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz> <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com> <20070618221021.GB2062@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618221021.GB2062@thunk.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 06:10:21PM -0400, Theodore Tso wrote:
> On Mon, Jun 18, 2007 at 02:31:14PM -0700, H. Peter Anvin wrote:
> > And that makes them different from extended attributes, how?
> > 
> > Both of these really are nothing but ad hocky syntactic sugar for
> > directories, sometimes combined with in-filesystem support for small
> > data items.
> 
> There's a good discussion of the issues involved in my LCA 2006
> presentation....  which doesn't seem to be on the LCA 2006 site.  Hrm.
> I'll have to ask that this be fixed.  In any case, here it is:
> 
> 	http://thunk.org/tytso/forkdepot.odp

Did you ever code up forkdepot ? Just wondering ?

Just because I now agree with you that streams are
a bad idea doesn't mean the pressure to support them
in some way in Samba has gone away :-).

Jeremy.
