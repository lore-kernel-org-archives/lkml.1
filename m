Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYEQQx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYEQQx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 12:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYEQQxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 12:53:49 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:45046 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752345AbYEQQxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 12:53:48 -0400
Date: Sat, 17 May 2008 12:53:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
	onX61s laptop
Message-ID: <20080517165330.GB8009@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	"Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
	"Barnes, Jesse" <jesse.barnes@intel.com>,
	"Packard, Keith" <keith.packard@intel.com>
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 09:02:32AM -0700, Pallipadi, Venkatesh wrote:
> Thanks for the log Ted. From first looks, I don't see any PAT
> related failures in the log. 

I forgot to add that I had tried booting with the "nopat" option, and
that didn't change anything, so yeah, it doesn't seem likely to be
related.

						- Ted
