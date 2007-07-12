Return-Path: <linux-kernel-owner+w=401wt.eu-S1763297AbXGLTIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297AbXGLTIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXGLTIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:08:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:45655 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbXGLTIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q81uxqXtjfJkLxAoqqHGZI7KyIBKnK84GUuYZFVxK7mnxDLLR7Oq6xnxk64I62TDtySJNtP99seMB8KBm14imQc/eOneC18wRBwww5AjRIbN712aAq6cDt6vA/4iAYJ+thzHmpFg+YIyt2ruHI2GNxzObW0rw9Fp3TmdJd9dfgg=
Message-ID: <29495f1d0707121208q4e8f2f16w45c65a3bd94c0a66@mail.gmail.com>
Date: Thu, 12 Jul 2007 12:08:21 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Chris Wright" <chrisw@sous-sol.org>
Subject: Re: [stable] Linux 2.6.22.1
Cc: "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
In-Reply-To: <20070712185219.GR4306@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710200637.GA5881@kroah.com>
	 <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com>
	 <20070712184106.GA22849@kroah.com>
	 <29495f1d0707121146k7b3a7175l1fcb40877e59cfaf@mail.gmail.com>
	 <20070712185219.GR4306@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Chris Wright <chrisw@sous-sol.org> wrote:
> * Nish Aravamudan (nish.aravamudan@gmail.com) wrote:
> > On 7/12/07, Greg KH <greg@kroah.com> wrote:
> > > That is a tree that Chris did, and I didn't realize we were maintaining
> > > it as the "official" stable tree, that is why it is not mentioned in the
> > > release notes :)
> >
> > Fair enough -- it's just a little bit easier from my side for
> > mirroring to only have to mirror one tree rather simply rather than
> > pulling multiple trees into one (and thus having to add to the list as
> > time goes on).
> >
> > > I'll let Chris decide if he wishes to maintain it or not, Chris?
>
> Nish, I think you might be the only user ;-)  I never figured out a nice
> way to do this w/out having a coherency issue (well, triggers aside).
> Ideally git would allow for something more transparent than
> alternatives, actual moving view to another tree.  It's possible with
> links, but that seems just dirty.  Short of that, do folks find the tree
> useful?  If so, I can work on some better automation to keep it
> up-to-date.

Well, if I'm the only one, I can work on something on my side :)
Thanks for the heads-up.

-Nish
