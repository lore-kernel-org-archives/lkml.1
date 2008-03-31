Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYCaVt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYCaVt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbYCaVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:49:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40746 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbYCaVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:49:51 -0400
Date: Mon, 31 Mar 2008 23:50:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080331215027.GC3714@elf.ucw.cz>
References: <20080320060550.GA13200@dose.home.local> <20080320105432.GA13404@dose.home.local> <20080325231300.GA10641@thinkpad.home.local> <200803290003.16199.rjw@sisk.pl> <20080331212812.GB5313@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331212812.GB5313@dose.home.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-31 23:28:12, Tino Keitel wrote:
> On Sat, Mar 29, 2008 at 00:03:15 +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > Can you please try to boot with acpi_new_pts_ordering and retest?
> 
> I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
> without success. I still got the same hand at resume.

You should put "acpi_new_pts_ordering" on kernel command line.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
