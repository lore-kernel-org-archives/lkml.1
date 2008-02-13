Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbYBMNp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbYBMNp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYBMNpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:45:43 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:31902 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYBMNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:45:42 -0500
Date: Wed, 13 Feb 2008 08:45:20 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, trenn@suse.de,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       lenb@kernel.org
Subject: Re: [PATCH 2/5] Provide acpi_check_{mem_}region.
Message-ID: <20080213134520.GB17512@jupiter.solarsys.private>
References: <1193236379.4590.229.camel@queen.suse.de> <20080207234002.e31563be.akpm@linux-foundation.org> <20080210132536.7c4d1cb1@hyperion.delvare> <20080211115546.87a738b1.akpm@linux-foundation.org> <20080211221829.7fcf749e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211221829.7fcf749e@hyperion.delvare>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Jean:

* Jean Delvare <khali@linux-fr.org> [2008-02-11 22:18:29 +0100]:
> On Mon, 11 Feb 2008 11:55:46 -0800, Andrew Morton wrote:
> > On Sun, 10 Feb 2008 13:25:36 +0100 Jean Delvare wrote:
> > > Andrew, both patches are
> > > 
> > > Acked-by: Jean Delvare <khali@linux-fr.org>
> > 
> > We already have Signed-off-by:you, which I figure outranks acked-by: ;)
> 
> Yeah but that wasn't the same me. That was me-developer-at-suse,
> who doesn't yet have the same aura as
> me-maintainer-of-i2c-and-former-maintainer-of-hwmon ;)
> 
> > > and I am totally fine with you pushing them to Linus now. But of course
> > > having Mark's ack would be good too.
> > 
> > That would be nice.  But I'll merge them mid-week anyway unless Mark actually
> > nacks them:
> > 
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
> > 
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
> 
> Yeah, sounds like a good plan, thanks for taking care.

OK, I pulled the first of those into my hwmon testing tree and merged
it, since there are trivial conflicts with some of the other patches
already there.  I'll send it to Linus before -rc2.

Andrew: hopefully that makes your life .001% easier. ;)

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

