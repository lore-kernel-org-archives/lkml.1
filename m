Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbZFPTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbZFPTTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZFPTTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:19:47 -0400
Received: from kroah.org ([198.145.64.141]:52805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbZFPTTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:19:46 -0400
Date: Tue, 16 Jun 2009 12:15:41 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Stefan Bader <stefan.bader@canonical.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       Tim Gardner <tim.gardner@canonical.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: Volunteering for stable patch review process
Message-ID: <20090616191541.GA29254@kroah.com>
References: <43e72e890906152230j7bd91086y26f3ab7fb3c0cfa7@mail.gmail.com> <20090616053718.GE30071@sequoia.sous-sol.org> <43e72e890906161132m4bfcf2cbpdf46712f1b7afeb5@mail.gmail.com> <4A37E7D1.7060109@canonical.com> <20090616184943.GA28969@kroah.com> <20090616190003.GG30071@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616190003.GG30071@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 12:00:03PM -0700, Chris Wright wrote:
> * Greg KH (greg@kroah.com) wrote:
> > Hm, we now have 17 people on the list.  This might be getting a bit
> > messy for some email systems to have such a large CC: list, perhaps we
> > should look into setting up an email list, like the stable-commits list
> > is used.
> 
> Heh, was just thinking the same.  Yup, think a list would be better.
> 
> > Or perhaps we should just use the stable-commits list instead?  Chris,
> > any thoughts?
> 
> stable-commits is good from my pov, but it's effectively read only.

Yeah, it's also higher volume which some reviewers might not like.

Should we create "stable-review" instead?

thanks,

greg k-h
