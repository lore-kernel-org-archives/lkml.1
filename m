Return-Path: <linux-kernel-owner+w=401wt.eu-S1032026AbXFHVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032026AbXFHVyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933269AbXFHVyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:54:06 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:46594 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750827AbXFHVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:54:05 -0400
X-YMail-OSG: 6HEs2UUVM1nQ1JvawdWclZr5fbz.8F2nhSVEN7WmECQjXzofLtpOb8jis1.gm6T_LrV3SauPhw--
X-RocketYMMF: rancidfat
Date: Fri, 8 Jun 2007 14:54:02 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
To: Pavel Machek <pavel@ucw.cz>,
       David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070608202400.GA4005@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <999952.62855.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pavel Machek <pavel@ucw.cz> wrote:


> AA solves less problems than SELinux does.

And vi solves less problems than OpenOffice.
vi is good for a different set of purposes than OpenOffice.
AA and SELinux both aspire to being Security Solutions,
but that does not make either a subset of the other.

> Some people like AA more,
> but I guess they should just learn SELinux.

Knowing the people involved I would suggest that the AA people
did learn SELinux, and came to their own conclusions regarding
it's applicability to their needs, and that those conclusions
are not the same as yours.
 
> And yes, I'm afraid this discussion is relevant on l-k, because we
> should have very good reasons before merging duplicate functionality.

'cmon, you know better than to claim that this is duplicate
functionality. No one is arguing that. The arguments have been
that the conceptual basis of named based access control are flawwed.
As that argument has failed to move the AA adherants, the old sawhorse
that SELinux does everything, or could be made to if you sweated the
policy hard enough, got pulled out. No evidence to that effect,
mind you, but the old "waves paw" nonetheless.

SELinux is the finest implementation of Type Enforcement on the planet.
TE does not match everyone's definition of security. AA is an
alternative that clearly has as tough a roe to hoe as SELinux did
in 2001, when it was up against MLS system vendors who compared it
to Froot Loops. Alternatives, even those that you don't personally
care for, are good for you.



Casey Schaufler
casey@schaufler-ca.com
