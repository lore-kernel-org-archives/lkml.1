Return-Path: <linux-kernel-owner+w=401wt.eu-S965393AbXCLJD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393AbXCLJD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965389AbXCLJD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:03:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58977 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965393AbXCLJD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:03:58 -0400
Date: Mon, 12 Mar 2007 10:03:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 3/3] mm: Remove unused page flags
Message-ID: <20070312090347.GE8330@elf.ucw.cz>
References: <200703111117.27083.rjw@sisk.pl> <200703111134.54143.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703111134.54143.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-03-11 11:34:53, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove the two page flags that were previously used by swsusp and are no longer
> needed.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
