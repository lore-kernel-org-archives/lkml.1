Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXKBShb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXKBShb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbXKBShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:37:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47020 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbXKBShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:37:20 -0400
Date: Fri, 2 Nov 2007 11:00:04 -0700
From: Greg KH <greg@kroah.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, npiggin@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] patch
	remove-broken-ptrace-special-case-code-from-file-mapping.patch
	queued to -stable tree
Message-ID: <20071102180004.GA22849@kroah.com>
References: <20071102162222.EC46D14540CB@imap.suse.de> <alpine.LFD.0.999.0711020945330.3342@woody.linux-foundation.org> <20071102165816.GA16493@suse.de> <472B59CC.9030206@redhat.com> <e9e943910711021052j4b5366c4u8b3ae87080e8b310@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e943910711021052j4b5366c4u8b3ae87080e8b310@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 05:52:25PM +0000, Duane Griffin wrote:
> On 02/11/2007, Chuck Ebbert <cebbert@redhat.com> wrote:
> > On 11/02/2007 12:58 PM, Greg KH wrote:
> > > Unless Nick really objects, and then I'll drop yours and use his, but I
> > > don't think that Duane verified that his patch fixed the issue.
> > >
> >
> > I put Nick's in Fedora, so it had better work...  ;)
> 
> I've tested both patches, and they both fix the problem. So no
> worries, either way :)
> 
> As Linus said, his patch does change the behaviour. I'm not qualified
> to judge how risky that is, however I think that the change is an
> improvement. In fact in my original bug report I suggested the old
> behaviour could be considered buggy and the new behaviour might be
> preferable.

Ok, thanks for letting me know.  I'll stick with Linus's patch for now,
unless someone really complains :)

thanks,

greg k-h
