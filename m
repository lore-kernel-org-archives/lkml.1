Return-Path: <linux-kernel-owner+w=401wt.eu-S1751607AbXDATJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbXDATJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXDATJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:09:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbXDATJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:09:49 -0400
Date: Sun, 1 Apr 2007 15:09:39 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 11/16] samba-eintr-fix.diff
Message-ID: <20070401190938.GA20060@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012009230.12316@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704012009230.12316@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 08:16:22PM +0200, Jan Engelhardt wrote:
 > 
 > From: Dave Jones
 > Already posted at http://lkml.org/lkml/2005/7/7/255

I had to stop and think if this was an April 1st :)
Back in 2005 it seemed I had a strong enough stomach
to wade through smbfs for some unknown reason.
These days like many others, I wish someone would
just put the thing out of its misery.

In Fedora we switched it off (in about 2005 iirc)
in favor of using cifs, which for the most part
is a drop-in replacement.  There still remain 1-2
corner cases where it doesn't work iirc, but
the situation is a lot better than it used to be.

As to whether the patch is worthwhile/correct..
I really don't know.  I posted it back then in the hopes
that someone smbfs-savvy would pop up and review it.
As you can see from the archive, no-one did.

	Dave

-- 
http://www.codemonkey.org.uk
