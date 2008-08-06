Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYHFAeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYHFAeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYHFAZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:25:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYHFAZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:25:35 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro
	toalinuxinterfaceforonaccess scanning
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
In-Reply-To: <20080806001124.GA9079@kroah.com>
References: <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	 <20080805185438.GA8453@mit.edu>
	 <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com>
	 <20080805211445.GA28304@kroah.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
	 <20080805214415.GA5830@kroah.com>
	 <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com>
	 <20080805222638.GA6395@kroah.com>
	 <20080805233743.GK28946@ZenIV.linux.org.uk>
	 <1217980132.27684.203.camel@localhost.localdomain>
	 <20080806001124.GA9079@kroah.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 20:25:29 -0400
Message-Id: <1217982329.27684.214.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 17:11 -0700, Greg KH wrote:
> On Tue, Aug 05, 2008 at 07:48:52PM -0400, Eric Paris wrote:
> > On Wed, 2008-08-06 at 00:37 +0100, Al Viro wrote:
> > > On Tue, Aug 05, 2008 at 03:26:38PM -0700, Greg KH wrote:
> > > > On Tue, Aug 05, 2008 at 06:12:34PM -0400, Press, Jonathan wrote:
> > > > > Sorry for the top-post... but I give up.
> > > > >  
> > > > > I don't think I'm stupid, but frankly I don't understand the point of
> > > > > the questions being asked in the last three responses to my statement.
> > > > > I don't know why they are relevant, and I don't know how to answer
> > > > > them in a framework that we can all understand at the same time.
> > > 
> > > Excuse me?  One of those questions had been a very specific yes-or-no one
> > > and I certainly hope that we all can understand either answer to such...
> > > 
> > > For the record, the question is
> > > 
> > > "Do you or do you not expect the malware to be active on scanning host?"
> > 
> > I do believe for a number of AV vendors the answer is yes.  I will try
> > to have some offline conversations with the right people at a number of
> > vendors and work to better define the threats that they wish to or
> > believe they are able to help mitigate.
> 
> This is troubling to me.  Why "offline conversations"?  Why are you
> being forced to be the mediator here?  Why will these companies not
> contribute directly to the development of this code/model in public,
> like all other major Linux kernel contributions?

I'm going to be trying to get them to talk offline because obviously few
people from the AV industry are stepping up online.  I'm told we'll be
hearing from Sophos tomorrow and hopefully they will have read all of
today chatter and will form a coherent position.

> Isn't this the point of the malware-list in the first place?

Yes it is, hopefully if we can move parts of this conversation to
malware list the AV vendors will feel a bit less like this is an us
against them proposition and more like a collaborative effort.  From my
point of view I'd have to say that everyone has been refreshingly
polite   :)

> For them to hide behind _anyone_ seems very suspect.

I don't think its hiding, I'm attempting to bring these companies who
just don't understand how to work in public after years of building
walls along at a reasonable pace so noone feels they have to give up or
that finding a real solution is an impossible task.

-Eric

