Return-Path: <linux-kernel-owner+w=401wt.eu-S1762212AbYHEXtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762212AbYHEXtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYHEXtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:49:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbYHEXtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:49:02 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro
	toalinuxinterfaceforonaccess scanning
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org
In-Reply-To: <20080805233743.GK28946@ZenIV.linux.org.uk>
References: <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805181141.GA10700@kroah.com>
	 <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	 <20080805185438.GA8453@mit.edu>
	 <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com>
	 <20080805211445.GA28304@kroah.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com>
	 <20080805214415.GA5830@kroah.com>
	 <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com>
	 <20080805222638.GA6395@kroah.com>
	 <20080805233743.GK28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 19:48:52 -0400
Message-Id: <1217980132.27684.203.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 00:37 +0100, Al Viro wrote:
> On Tue, Aug 05, 2008 at 03:26:38PM -0700, Greg KH wrote:
> > On Tue, Aug 05, 2008 at 06:12:34PM -0400, Press, Jonathan wrote:
> > > Sorry for the top-post... but I give up.
> > >  
> > > I don't think I'm stupid, but frankly I don't understand the point of
> > > the questions being asked in the last three responses to my statement.
> > > I don't know why they are relevant, and I don't know how to answer
> > > them in a framework that we can all understand at the same time.
> 
> Excuse me?  One of those questions had been a very specific yes-or-no one
> and I certainly hope that we all can understand either answer to such...
> 
> For the record, the question is
> 
> "Do you or do you not expect the malware to be active on scanning host?"

I do believe for a number of AV vendors the answer is yes.  I will try
to have some offline conversations with the right people at a number of
vendors and work to better define the threats that they wish to or
believe they are able to help mitigate.

-Eric

> I hope that relevance of that to the analysis of software involved in
> scanning should be obvious.

