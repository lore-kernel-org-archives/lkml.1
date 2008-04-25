Return-Path: <linux-kernel-owner+w=401wt.eu-S1764856AbYDYWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764856AbYDYWjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYDYWjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:39:13 -0400
Received: from vena.lwn.net ([206.168.112.25]:35394 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbYDYWjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:39:13 -0400
To: Greg KH <greg@kroah.com>
Subject: Re: [PULL] A few documentation updates 
From: corbet@lwn.net (Jonathan Corbet)
Cc: torvalds@linux-foundation.org, viro@parcelfarce.linux.theplanet.co.uk,
       linux-kernel@vger.kernel.org
In-reply-to: Your message of "Fri, 25 Apr 2008 15:32:48 PDT."
             <20080425223248.GB12643@kroah.com> 
Date: Fri, 25 Apr 2008 16:39:12 -0600
Message-ID: <1972.1209163152@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote:

> >       Various fixes to Documentation/HOWTO
> 
> No objection from me, thanks for doing this.  I do normally cc: all of
> the different translation maintainers of this file when it is changed so
> they know to update their translations where necessary.  Do you want me
> to do that?

At the moment, I think, you're the only one capable of doing that.

Should we maybe add a list of translators to the end of the document so
people know who to notify?  Either that, perhaps, or people like me
should keep their grubby mitts off the file and make all changes through
you so this notification can happen.  If you'd prefer that sort of
policy, maybe a note to that effect would be a good addition.

Or maybe kernel.org needs rss feeds for each file so people can
subscribe to the commit messages they're interested in :)

jon
