Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZDWScH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZDWScH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbZDWSbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:31:51 -0400
Received: from www.sr71.net ([198.145.64.142]:34418 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZDWSbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:31:50 -0400
Subject: Re: 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
From: Dave Hansen <dave@sr71.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, lenb@kernel.org,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090422204557.10c3cc37.akpm@linux-foundation.org>
References: <1240335038.11194.11.camel@nimitz>
	 <20090422204557.10c3cc37.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 11:31:48 -0700
Message-Id: <1240511508.10627.159.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 20:45 -0700, Andrew Morton wrote:
> (Is jstultz@us.ibm.com correct?)

Only I want it to go to the black hole which is Lotus Notes. :)

> On Tue, 21 Apr 2009 10:30:38 -0700 Dave Hansen <dave@sr71.net> wrote:
> > This was during my first boot of 2.6.30-rc2.
> 
> Did it ever happen again?

I've seen it on three different boots, but the stack traces were a bit
different each time.  So, I assume it is a true timekeeping thing
instead of something *actually* locking up.

> I assume this is a post-2.6.29 regression?  (Yet another.  We've been
> extra bad this time)

This laptop has been quite good to me and I haven't rebooted since the
late 2.6.28 days.  It isn't anything special, though.  Just a Lenovo
T61.  I wonder if my .config is a bit different.

-- Dave

