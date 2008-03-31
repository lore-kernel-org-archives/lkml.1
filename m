Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYCaV1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYCaV1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbYCaV1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:27:30 -0400
Received: from eazy.amigager.de ([213.239.192.238]:41810 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbYCaV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:27:29 -0400
Date: Mon, 31 Mar 2008 23:28:12 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini
	Core Duo
Message-ID: <20080331212812.GB5313@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@ucw.cz>
References: <20080320060550.GA13200@dose.home.local> <20080320105432.GA13404@dose.home.local> <20080325231300.GA10641@thinkpad.home.local> <200803290003.16199.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803290003.16199.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 00:03:15 +0100, Rafael J. Wysocki wrote:

[...]

> Can you please try to boot with acpi_new_pts_ordering and retest?

I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
without success. I still got the same hand at resume.

Regards,
Tino

