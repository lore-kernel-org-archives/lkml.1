Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYBRFi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYBRFi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYBRFiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:38:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36011 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYBRFiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:38:19 -0500
Date: Sun, 17 Feb 2008 21:37:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Message-ID: <20080217213733.0c46a98f@laptopd505.fenrus.org>
In-Reply-To: <200802172304.00322.rjw@sisk.pl>
References: <200802172304.00322.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 23:03:59 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> [This is a bit late, for which I'm sorry, but I waited for things to
> calm down a bit, to have something less of a moving target.
> 
> Now, following an Ingo's advice, the list has been generated directly
> out of the Bugzilla entries used for tracking the bugs.  I'm going to
> release the script used for generating the list, so that it can be
> recreated by anyone on the fly.]
> 
> This message contains a list of some regressions from 2.6.24 reported
> since 2.6.25-rc1 was released, for which there are no fixes in the
> mainline I know of.  If any of them have been fixed already, please
> let me know.
> 
> If you know of any other unresolved regressions from 2.6.24, please
> let me know either and I'll add them to the list.  Also, please let
> me know if any of the entries below are invalid.


question: can we please list the last known good version for each entry?
Since these are all regressions (right?) that information ought to be available
and usually helps down in narrowing causes..


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
