Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbXFPC51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbXFPC51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 22:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXFPC5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 22:57:19 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:41531 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751111AbXFPC5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 22:57:18 -0400
X-YMail-OSG: 7ulriqQVM1nLpBOWbtb6.oix2zRc0Nru_6WNePxhMVGqeCqpHaTHIoaLxKyGj6BqnBj97SSRsw--
X-RocketYMMF: rancidfat
Date: Fri, 15 Jun 2007 19:57:17 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
To: James Morris <jmorris@namei.org>, Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Line.LNX.4.64.0706152057390.29737@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <979511.88139.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- James Morris <jmorris@namei.org> wrote:

> On my system, it takes about 1.2 seconds to label a fully checked out 
> kernel source tree with ~23,000 files in this manner

That's an eternity for that many files to be improperly labeled.
If, and the "if" didn't originate with me, your policy is
demonstrably correct (how do you do that?) for all domains
you could claim that the action is safe, if not ideal. 
I can't say if an evaluation team would buy the "safe"
argument. They've been known to balk before.


Casey Schaufler
casey@schaufler-ca.com
