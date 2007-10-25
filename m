Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbXJYJU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbXJYJU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXJYJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:20:20 -0400
Received: from ns.firmix.at ([62.141.48.66]:1649 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbXJYJUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:20:19 -0400
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
	 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 25 Oct 2007 11:19:50 +0200
Message-Id: <1193303990.18559.28.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.312 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.312 required=5
X-Spam-Score: -2.312 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2007-10-24 at 17:35 -0700, Ray Lee wrote:
[....]
> Key-based masterlocks are easily broken with freon, and their combo
> locks are easily brute-forced in about ten minutes. Yet, I'll still
> use them to lock up my bike and garage.

The question is what the security threat is and the value of the secured
items.

> The idea that poor security is worse than no security is fallacious,
> and not backed up by common experience.

The common experience is, that common people just *feel* safer (just
because they have poor security).
With no security, they know that there is no security. With poor
security, they do not know (or can deny) that they have next to no real
security.
The prime example here is the usual (so-called) "personal firewall" on
Windows where people work normally as "administrator".

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


