Return-Path: <linux-kernel-owner+w=401wt.eu-S965546AbXBOOod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965546AbXBOOod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXBOOod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:44:33 -0500
Received: from ns.firmix.at ([62.141.48.66]:41962 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965546AbXBOOob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:44:31 -0500
Subject: Re: GPL vs non-GPL device drivers
From: Bernd Petrovitsch <bernd@firmix.at>
To: v j <vj.linux@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070214231143.11ff6b46.rdunlap@xenotime.net>
	 <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 15 Feb 2007 15:43:54 +0100
Message-Id: <1171550634.10976.31.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.416 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.416 required=5
X-Spam-Score: -2.416 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 23:28 -0800, v j wrote:
> On 2/14/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > At least one of us is confused about that an embedded User is.
> > It seems to me that you are an embedded developer, not User.
> > I doubt that most Embedded Users care what their OS is,
> > or even know what an OS is.
> 
> I am not sure what the difference is. We are trying to use Linux to
> support our application. It may be that Linux has a bug, or our
> application. When it is Linux, that has the problem, I  have tried to
> inform the community of that.

It would be much more helpful - especially for your product - to fix the
bug. And to stay "open" you can also submit the patch.

> > > Not everybody has to be a contributor. The reason Linux is popular is
> > > because of its openness. Take that away and see where it goes.
> >
> > We seem to have different definitions of open and closed.
> 
> Open = 3rd party Linux drivers can be loaded. Closed = No third party
> Linux drivers can be loaded.

You can always load 3rd party drivers - even if you compile module
support out of it.
Or do you really meant: Closed == No closed source 3rd party drivers
will be loaded because it is the decision of the company that pays the
developers.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

