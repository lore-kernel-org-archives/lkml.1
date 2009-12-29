Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZL2Plu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZL2Plu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZL2Plh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:41:37 -0500
Received: from isilmar.linta.de ([213.133.102.198]:52163 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752435AbZL2Plf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:41:35 -0500
Date: Tue, 29 Dec 2009 16:38:02 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #14908] 256MB CF card no longer recognized in PCMCIA slot
Message-ID: <20091229153802.GA24663@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
 <NJVdobuNFNK.A.6eH.WnhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NJVdobuNFNK.A.6eH.WnhOLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 04:09:59PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

It's already fixed in 2.6.33-rc2, see http://lkml.org/lkml/2009/12/28/228
for details. I'll also close the bugzilla entry.

Best,
	Dominik
