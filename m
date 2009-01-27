Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZA0Pcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZA0Pcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZA0Pco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:32:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60326 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbZA0Pcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:32:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: X200 suspend issue / linux-next: Tree for January 21
Date: Tue, 27 Jan 2009 16:31:59 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: "Nico -telmich- Schottelius" <nico-linux-next@schottelius.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20090121150249.a87aca09.sfr@canb.auug.org.au> <20090121144420.GA20617@denkbrett.schottelius.org> <20090127140558.GA24950@elf.ucw.cz>
In-Reply-To: <20090127140558.GA24950@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271632.00026.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009, Pavel Machek wrote:
> On Wed 2009-01-21 15:44:20, Nico -telmich- Schottelius wrote:
> > Hello!
> > 
> > News: The system freezes for almost a second and wakes up again!
> > 
> > At least no crash this time!
> 
> Good.
> 
> Maybe the suspends-then-autoresumes exists in 2.6.29-rc2, too...? Can
> you try disabling CONFIG_USB?

That would be http://bugzilla.kernel.org/show_bug.cgi?id=12399 , I think.

Thanks,
Rafael
