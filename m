Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYDAG1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYDAG1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYDAG0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:26:53 -0400
Received: from eazy.amigager.de ([213.239.192.238]:37488 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYDAG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:26:52 -0400
Date: Tue, 1 Apr 2008 08:27:34 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Soeren Sonnenburg <sonne@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080401062734.GA8824@dose.home.local>
Mail-Followup-To: Soeren Sonnenburg <sonne@nn7.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@ucw.cz>
References: <20080320060550.GA13200@dose.home.local> <20080320105432.GA13404@dose.home.local> <20080325231300.GA10641@thinkpad.home.local> <200803290003.16199.rjw@sisk.pl> <20080331212812.GB5313@dose.home.local> <1207030991.11035.35.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207030991.11035.35.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 06:23:11 +0000, Soeren Sonnenburg wrote:
> On Mon, 2008-03-31 at 23:28 +0200, Tino Keitel wrote:
> > On Sat, Mar 29, 2008 at 00:03:15 +0100, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > > Can you please try to boot with acpi_new_pts_ordering and retest?
> > 
> > I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
> > without success. I still got the same hand at resume.
> 
> I am having the hang on resume problem too (macbook pro), cf.
> http://bugzilla.kernel.org/show_bug.cgi?id=10319, 2.6.24 was fine.

What about 2.6.25-rc5? Up to this, resume works for me. -rc6 is broken.

Regards,
Tino
