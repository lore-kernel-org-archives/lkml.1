Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZJ0Q0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZJ0Q0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbZJ0Q0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:26:09 -0400
Received: from kroah.org ([198.145.64.141]:59456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbZJ0Q0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:26:05 -0400
Date: Tue, 27 Oct 2009 09:23:14 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: linux-next: manual merge of the staging tree with the
 net/wireless tree
Message-ID: <20091027162314.GA23768@kroah.com>
References: <20091027183503.5c398311.sfr@canb.auug.org.au>
 <20091027141325.GA17352@kroah.com>
 <20091027145631.GB15566@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027145631.GB15566@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 10:56:31AM -0400, John W. Linville wrote:
> On Tue, Oct 27, 2009 at 07:13:25AM -0700, Greg KH wrote:
> > On Tue, Oct 27, 2009 at 06:35:03PM +1100, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > Today's linux-next merge of the staging tree got conflicts in
> > > drivers/net/wireless/Kconfig between commits
> > > 3d23e349d807177eaf519d444677cee86b1a04cf ("wext: refactor") and
> > > 0465af8e03bdc6cd0b49dc5548671387a8674b69 ("libertas: separate libertas'
> > > Kconfig in it's own file") from the net/wireless tree and various commits
> > > ("... move driver to staging") from the staging tree.
> > > 
> > > I fixed it up (see below) and added a merge fixup (see further below) and
> > > can carry these as necessary (though it may be easier for everyone (i.e.
> > > me :-)) if these 4 staging tree commits are moved to the wireless
> > > tree ...).
> > 
> > John, I have no objection to these 4 commits going through your tree, if
> > it will make these types of merge issues go away.  If so, I have 4 more
> > patches that should be added, adding the TODO files for the drivers.  I
> > can send them to you if you want to take them.
> 
> Sure, that would be fine.  I did get copies of the TODO addition
> patches, but I deleted them as I had not yet seen this. :-(  Could
> you resend them to me?

Now sent.

thanks,

greg k-h
