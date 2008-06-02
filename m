Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYFBQo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYFBQo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYFBQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:44:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34150 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYFBQot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:44:49 -0400
Date: Mon, 2 Jun 2008 17:44:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Roger Heflin <rogerheflin@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Guntsche Michael <mike@it-loops.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Message-ID: <20080602164434.GA14012@srcf.ucam.org>
References: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com> <20080530065717.44cf7414@infradead.org> <F2473A1D-E4F5-4B9D-9538-B122553E1011@it-loops.com> <E234E250-922E-45F6-B01E-0B3CDC80A8ED@it-loops.com> <20080601185643.3d3db64f@infradead.org> <48435CCA.5000905@gmail.com> <20080602153759.GA3406@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602153759.GA3406@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 12:37:59PM -0300, Henrique de Moraes Holschuh wrote:

> Indeed.  And if we had a generic interface for throttling (ACPI
> T-states-like) and frequency changes (ACPI P-states-like), we could just
> move p4-clockmod to the throttling one (and NOT letting it register with
> the frequency changes interface), and be done with it.
> 
> Do we have these interfaces?

No.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
