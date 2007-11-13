Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbXKMR0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbXKMR0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbXKMR0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:26:17 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59215 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbXKMR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:26:14 -0500
Date: Tue, 13 Nov 2007 08:43:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, mbligh@mbligh.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-input@atrey.karlin.mff.cuni.cz, bugme-daemon@bugzilla.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113084357.1eacf89d.randy.dunlap@oracle.com>
In-Reply-To: <1194968001.3416.12.camel@localhost.localdomain>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	<20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<1194968001.3416.12.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 09:33:21 -0600 James Bottomley wrote:

> On Tue, 2007-11-13 at 03:15 -0800, Andrew Morton wrote:
> > >
> > SCSI==================================================================
> > > 
> > > qla2xxx: driver initialization does not complete when booting with
> > > Port connected
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9267
> > > Kernel: 2.6.23.1
> > 
> > No response from developers
> 
> Urm, well, if no-one ever tells the SCSI list it's unrealistic to expect
> anyone to be working on it.  As far as I can tell, email was sent to
> Andrew Vasquez only on 31 October. However, the fault looks to be
> generic, so he probably just dropped it.

It seems that new SCSI bugs need to be sent to linux-scsi@vger.kernel.org.

Martin, can you arrange that to happen automatically instead of
Andrew having to do it manually?

---
~Randy
