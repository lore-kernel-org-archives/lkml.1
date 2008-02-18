Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYBRD6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYBRD6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYBRD6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:58:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbYBRD6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:58:01 -0500
From: Neil Brown <neilb@suse.de>
To: Paul Jackson <pj@sgi.com>
Date: Mon, 18 Feb 2008 14:58:05 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18361.589.539575.437863@notabene.brown>
Cc: torvalds@linux-foundation.org, corbet@lwn.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags, one more time
In-Reply-To: message from Paul Jackson on Sunday February 17
References: <9525.1202489479@vena.lwn.net>
	<alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
	<18360.62530.142639.141506@notabene.brown>
	<20080217211525.09ae860f.pj@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday February 17, pj@sgi.com wrote:
> Neil responding to Linus:
> > > "From:" is not a tag. It's a special marker at the *top*
> >
> > You may be right, but when I email patches to akpm
> 
> Linus wasn't saying you don't need a 'From:' line in this case (as the
> *top* line of patches you didn't author).  He's saying it's not an
> instance of the type "tag" line, such as the "Signed-off-by:" line that
> go after the patch explanation.  The "From:" line is a different kind
> of line, with different rules and position.

If it looks like a duck and quacks like a duck.....

When Linus used "From" "Subject" and "Date" together in the context of
"mail", it sounded a lot like he was talking about the headers section
of a standard mail item.  I guess he wasn't.

I don't really care if "From:" gets called a 'tag' or what, but given
that it is an important piece of metadata associated with a patch, it
seems good to document it in the same place as other important pieces
of metadata that are associated with patches.

NeilBrown

