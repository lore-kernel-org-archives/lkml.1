Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbXFYPJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbXFYPJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXFYPJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:09:00 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:25184 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755438AbXFYPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:08:59 -0400
X-YMail-OSG: 4Xwca0AVM1khyT..8NYqZCRQ_W.amIZSN6OjHsRoFOxlp5LdilOB9sEDJhhO6dllYUHjIZ8yqA--
X-RocketYMMF: rancidfat
Date: Mon, 25 Jun 2007 08:08:58 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <20070625143222.GA11997@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <409527.74718.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serge@hallyn.com> wrote:


> > I think the value is overrated. You would never want to do that
> > in a production environment, and in a debug environment you could
> > just as easily reboot and get some start-up testing out of the way.
> 
> And in a development environment you can just as easily select
> CONFIG_XYZ=y, no?
> 
> So we have two options, one which provides greater choice and
> flexibility.

I have no problem with leaving things the way they are today,
and none with the proposed change. Either way works for me. It
would be a little bit better for me if it stayed as is, but that's
not a coding issue.


Casey Schaufler
casey@schaufler-ca.com
