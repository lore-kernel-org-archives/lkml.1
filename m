Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbZIJDEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbZIJDEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZIJDEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:04:11 -0400
Received: from kroah.org ([198.145.64.141]:44589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZIJDEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:04:10 -0400
Date: Wed, 9 Sep 2009 20:00:05 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 00/71] 2.6.30.6-stable review
Message-ID: <20090910030005.GA32218@kroah.com>
References: <20090905001824.GA18171@kroah.com>
 <43e72e890909081223w3e50eee6v438411462a7ed534@mail.gmail.com>
 <20090909224455.GB2077@kroah.com>
 <43e72e890909091721r3016db52i7328bac5d978c26c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43e72e890909091721r3016db52i7328bac5d978c26c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 05:21:34PM -0700, Luis R. Rodriguez wrote:
> On Wed, Sep 9, 2009 at 3:44 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Sep 08, 2009 at 12:23:29PM -0700, Luis R. Rodriguez wrote:
> >> On Fri, Sep 4, 2009 at 5:18 PM, Greg KH<gregkh@suse.de> wrote:
> >> > This is the start of the stable review cycle for the 2.6.30.6 release.
> >> > There are 71 patches in this series, all will be posted as a response to
> >> > this one.  If anyone has any issues with these being applied, please let
> >> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> >> > to add a Signed-off-by: line to the patch, please respond with it.
> >> >
> >> > These patches are sent out with a number of different people on the Cc:
> >> > line.  If you wish to be a reviewer, please email stable@kernel.org to
> >> > add your name to the list.
> >>
> >> I think this automated message needs some updated to reflect the fact
> >> that a mailman list is used now, and redirect people to help
> >> themselves to help us by subscribing to:
> >>
> >> http://linux.kernel.org/mailman/listinfo/stable-review
> >>
> >> > If you want to be off the reviewer list,
> >> > also email us.
> >>
> >> This seems to not be required any more.
> >
> > True.  Care to send a patch against the stable-queue where this message
> > is:
> >        http://git.kernel.org/?p=linux/kernel/git/chrisw/stable-queue.git;a=summary
> 
> Sure, that hasn't been updated since 2006, is that the right tree?

Bah, no, it isn't, use the one in the git/stable/stable-queue.git
location, sorry about that.

Chris, you might want to delete this old one :)

thanks,

greg k-h
