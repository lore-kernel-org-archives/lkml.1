Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXFRXhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXFRXhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbXFRXhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:37:00 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:33023 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbXFRXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:36:59 -0400
X-IronPort-AV: i="4.16,436,1175497200"; 
   d="scan'208"; a="495441618:sNHT45767920"
To: Christoph Lameter <clameter@sgi.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>, carlo@alinoe.com,
       Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
       GIT <git@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
X-Message-Flag: Warning: May contain useful information
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de>
	<Pine.LNX.4.64.0706181617060.18601@schroedinger.engr.sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 18 Jun 2007 16:36:56 -0700
In-Reply-To: <Pine.LNX.4.64.0706181617060.18601@schroedinger.engr.sgi.com> (Christoph Lameter's message of "Mon, 18 Jun 2007 16:18:32 -0700 (PDT)")
Message-ID: <adavedkesx3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jun 2007 23:36:57.0002 (UTC) FILETIME=[8F2B00A0:01C7B201]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Is there some way you can feed that into Debian please? Why the go around 
 > through a separate repository? The maintainer of git-core is not actively 
 > maintaining the package?

No.  The current version of git in Debian is 1.5.2.1, a little out of
date from the current 1.5.2.2 but not too bad.  However, Debian Etch
was already released with an older version of git.  Debian
testing/Lenny (the next release, which is still being developed) does
not have the latest version of git yet because it is blocked waiting
for the next version of curl as well as a few other problems.

 - R.
