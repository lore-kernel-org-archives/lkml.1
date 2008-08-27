Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYH0WoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYH0WoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYH0WoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:44:10 -0400
Received: from outbound-mail-38.bluehost.com ([69.89.20.192]:48756 "HELO
	outbound-mail-38.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752339AbYH0WoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:44:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=GZRu9SnvVNLxtXvihmJgiu2ArbqTnBljgz4htbuplu/r0oJUd1k9Om7i6vPdl6junexgjQioXARfrgbjCLMN4qtx/Z6YDImUwwfGboZ9IY5hbFNnjrUnK6oCPaCKWwWR;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH, v2] PCI: create function symlinks in /sys/bus/pci/slots/N/
Date: Wed, 27 Aug 2008 15:44:02 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080827142139.GB19788@parisc-linux.org> <20080827150438.GA30929@kroah.com>
In-Reply-To: <20080827150438.GA30929@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271544.02857.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2008 8:04 am Greg KH wrote:
> On Wed, Aug 27, 2008 at 08:21:39AM -0600, Matthew Wilcox wrote:
> > On Tue, Aug 26, 2008 at 09:01:35PM -0700, Greg KH wrote:
> > > On Tue, Aug 26, 2008 at 09:50:03PM -0600, Alex Chiang wrote:
> > > > * Greg KH <greg@kroah.com>:
> > > > > And thanks for the other documentation as well, if you want,
> > > > > you could split that out as a different patch and odds are
> > > > > Jesse could get that into the tree before 2.6.27 comes out :)
> > > >
> > > > Hrm, given the harder line Linus has taken against "regression
> > > > only" patches lately, it can probably wait another release cycle.
> > >
> > > Documentation updates and new stand-alone drivers are ok at all times
> > > :)
> >
> > You're clearly not hanging on every word of our Dear Leader:
> >
> > http://marc.info/?l=linux-kernel&m=121924636529367&w=2
>
> I read that, and parsed:
> 	I generally won't complain about them, but I also don't see the
> 	point.
>
> as being up to the maintainer's judgement.
>
> So in this case, it's up to Jesse :)

Linus seems cranky lately, no need to tempt him to flame me I think (besides I 
don't have any other critical stuff queued up atm; I'm definitely not going 
to ask him to pull just a doc update this late in the cycle).

-- 
Jesse Barnes, Intel Open Source Technology Center
