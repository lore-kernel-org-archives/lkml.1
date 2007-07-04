Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbXGDLDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbXGDLDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXGDLDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:03:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbXGDLDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:03:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 13:10:10 +0200
User-Agent: KMail/1.9.5
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707041233.18199.rjw@sisk.pl> <18059.31464.183382.358931@cargo.ozlabs.ibm.com>
In-Reply-To: <18059.31464.183382.358931@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041310.11336.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 12:48, Paul Mackerras wrote:
> Rafael J. Wysocki writes:
> 
> > So, I gather, you're volunteering to handle suspend-related bug reports
> > from the point in which we drop the freezer from the suspend code path?
> 
> Ben and I are happy to handle all the ones for the platform we
> maintain, which currently does suspend without freezing processes. :)

I mean all platforms.  After all, the $subject change won't affect yours.

BTW, does your platform's suspend work on SMP systems?

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
