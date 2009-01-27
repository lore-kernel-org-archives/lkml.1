Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZA0Qoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZA0Qoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZA0Qoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:44:34 -0500
Received: from lobo.ruivo.org ([66.92.68.119]:48763 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZA0Qod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:44:33 -0500
X-Greylist: delayed 1718 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 11:44:32 EST
Date: Tue, 27 Jan 2009 11:15:43 -0500
From: Aristeu Rozanski <aris@ruivo.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>,
       Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: X200 suspend issue / linux-next: Tree for January 21
Message-ID: <20090127161543.GA17749@cathedrallabs.org>
References: <20090121150249.a87aca09.sfr@canb.auug.org.au> <20090121144420.GA20617@denkbrett.schottelius.org> <20090127140558.GA24950@elf.ucw.cz> <200901271632.00026.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901271632.00026.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would be http://bugzilla.kernel.org/show_bug.cgi?id=12399 , I think.
I tried the attached patch with the current Linus' git tree and it fixes the
issue to me.
Thanks!

-- 
Aristeu

