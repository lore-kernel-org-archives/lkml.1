Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYFGKcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYFGKcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 06:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYFGKca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 06:32:30 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:58628 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYFGKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 06:32:29 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend and hibernation patchset for 2.6.26-rc3
Date: Sat, 7 Jun 2008 11:21:57 +0100
User-Agent: KMail/1.9.9
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <200805212329.59539.rjw@sisk.pl>
In-Reply-To: <200805212329.59539.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806071121.59619.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sat, 07 Jun 2008 10:22:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008 22:29:57 Rafael J. Wysocki wrote:
> Patches 01-06 and 11 have been sent to Len as 2.6.27 material.  They have
> been tested by me for some time (except for the most recent changes in
> patches 01 and 11) and have not lead to any problems so far.

Patch 11:

Tested-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

My box can now suspend & resume quite happily with acpi_sleep=old_ordering

(That's on latest 2.6.26 git + the patch series on top).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
