Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbXIYPHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbXIYPHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXIYPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:07:05 -0400
Received: from smtp-dmz-232-tuesday.dmz.nerim.net ([195.5.254.232]:56005 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751416AbXIYPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:07:03 -0400
Date: Tue, 25 Sep 2007 17:05:00 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Message-ID: <20070925150500.GA2632@localhost.localdomain>
References: <20070925065109.GA3080@localhost.localdomain> <20070925092755.GA4553@localhost.localdomain> <20070925095855.GA4982@localhost.localdomain> <200709251345.11370.rjw@sisk.pl> <20070925120202.GA5641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925120202.GA5641@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Will test this evening the patch you pointed in your next message.

Ok, with both patches (including the very latest one from Alexey ---
tried the "stylistically correct" one), machine halts fine again. Thanks
to all for having looked at this!

-- 
Damien Wyart
