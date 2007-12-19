Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXLSRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXLSRFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXLSRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:05:44 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35962 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXLSRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:05:44 -0500
Date: Wed, 19 Dec 2007 10:05:42 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Filippos Papadopoulos <psybases@gmail.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
Message-ID: <20071219170542.GC26272@parisc-linux.org>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com> <20071217031841.f483e5ac.akpm@linux-foundation.org> <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com> <47666904.8060605@panasas.com> <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com> <20071219132918.GB26272@parisc-linux.org> <1198083040.5487.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198083040.5487.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 10:50:40AM -0600, James Bottomley wrote:
> So, to get the best of both worlds, file a bugzilla and note the bugid.
> Then email a complete report to the relevant list, but add [BUG <bugid>]
> to the subject line and cc bugme-daemon@bugzilla.kernel.org  If you do
> this, bugzilla will keep track of the entire discussion as it progresses
> and allow those who track bugs through bugzilla to get a pretty accurate
> idea of the status.  You should never need to touch bugzilla again once
> the initial bug report is filed: all future information flow is via the
> mailing lists.

The problem is that it appears to the casual observer as if they can
then add information to the bug through the web interface.  But that
information will never be forwarded to the mailing list.  Unless there's
a way of marking bugs as 'unchangable through the web interface' or 'all
messages appended to this bug need to be forwarded', Bugzilla just
doesn't fit our needs.

The Debian BTS fits our way of working much better.  Perhaps somebody
should investigate a migration.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
