Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbXKXSuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbXKXSuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXKXSty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:49:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXKXStx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:49:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: "buggy cmd640" message followed by soft lockup
Date: Sat, 24 Nov 2007 20:07:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200711222007.12497.elendil@planet.nl> <200711241904.13132.bzolnier@gmail.com>
In-Reply-To: <200711241904.13132.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711242007.52430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 24 of November 2007, Bartlomiej Zolnierkiewicz wrote:
[--snip--]
> Rafael, I see that you've filled a bug for this bugreport into kernel
> bugzilla tracker (one day after the bugreport):
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=9442
> 
> Since we try to address regressions with the highest priority in the
> IDE-land (and usually they get fixed quickly) I would strongly prefer to
> use bugzilla only for long-term bugs and avoid the needless bureaucracy.

As a rule, I put all of the reported regressions into the Bugzilla early.  You
are not required to use these entries for tracking the bugs, though.  If you
don't want to, just leave the entry as is and I'll close it when the fix is in
the Linus' tree.

> Therefore I kindly ask you to defer filling bugs for new bugreports for
> a week or two, and give us some time to react (and always ping me about
> the bugreport status before filling bugzilla entry).

Well, I thought you'd get an email from the Bugzilla, but of course I can notify
you directly about reported regressions related to IDE.

> The alternative solution would be that you fill all new bugreports but
> then please assign them to yourself and track their status (if after two
> weeks the problem is not fixed feel free to reassign bug to me).

I can do that, but please note that the bugs filed against IDE are assigned to
you automatically, so I'll have to reassign them to me (as I've just done with
this particular entry).  If you don't want them to be assigned to you at all,
please contact the Bugzilla administrators and ask them to change that.

Thanks,
Rafael
