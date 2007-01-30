Return-Path: <linux-kernel-owner+w=401wt.eu-S965601AbXA3Qsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965601AbXA3Qsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965602AbXA3Qsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:48:51 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:48977 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965601AbXA3Qsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:48:50 -0500
Subject: Re: [Ksummit-2007-discuss] Re: [Ksummit-2006-discuss] 2007 Linux
	Kernel Summit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Greg Ungerer <greg_ungerer@securecomputing.com>,
       linux-kernel@vger.kernel.org, ksummit-2007-discuss@thunk.org
In-Reply-To: <20070130103044.GB10526@infradead.org>
References: <20070126032849.GB5589@thunk.org>
	 <8355959a0701260704x6aea8141s3d0581fa33c74cf2@mail.gmail.com>
	 <20070126195024.GE14759@thunk.org> <45BE8BF9.6020204@sgi.com>
	 <20070130030430.GA21772@redhat.com> <45BEBBF0.3050102@snapgear.com>
	 <20070130034111.GB21772@redhat.com> <45BEC303.2040205@securecomputing.com>
	 <20070130040826.GA19362@linux-sh.org> <20070130043421.GE21772@redhat.com>
	 <20070130103044.GB10526@infradead.org>
Content-Type: text/plain
Date: Tue, 30 Jan 2007 10:48:45 -0600
Message-Id: <1170175725.3420.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 10:30 +0000, Christoph Hellwig wrote:
> On Mon, Jan 29, 2007 at 11:34:21PM -0500, Dave Jones wrote:
> > It might be worth putting together a list of do's and don'ts for the
> > CPU architects if we have a panel again this year (and its usually
> > a fairly popular session, so I'd be surprised if it got dropped).
> > something along the lines of
> 
> Count my vote for dropping the cpu panels session.  It's been far
> too marketing oriented, and all of the companies have far more interesting
> meetings of their own where thos caring about a particular architecture
> (and that includes much more than just the cpu!) can have usefull discussions.

Well, OK, but the next question is that is some form of panel of
outsiders still a useful feature?

Previous panels we've done have been:

      * Device Drivers - Inputs from vendors trying to get code into the
        kernel.  I had feedback that this was reasonably useful; the
        problem is that it tends to be composed of vendors already
        making a big effort on the open source process and not the ones
        (like graphics) who aren't.
      * Customer Panel - inputs from various users deploying linux in
        their enterprises.  This did tend to degenerate quickly to a
        list of requirements.

The one everyone seems to want is chipsets, so is this the one we want
to shoot for this year?

James


