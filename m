Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbZBYJdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbZBYJdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZBYJdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:33:32 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39541 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZBYJdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:33:31 -0500
Message-ID: <49A51061.2040300@davidnewall.com>
Date: Wed, 25 Feb 2009 20:03:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Tomas M <tomas@slax.org>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Theodore Tso <tytso@mit.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl>	 <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org>	 <49A3AC14.2050107@slax.org>  <20090224141548.GB5482@mit.edu> <1235488695.15148.49.camel@moss-terrapins.epoch.ncsc.mil> <49A4F3EC.7060005@slax.org>
In-Reply-To: <49A4F3EC.7060005@slax.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas M wrote:
> In general, I need an union filesystem and I do not care if that is unionfs or aufs.

Agreed. Well said.

> I wish aufs to be mainlined; because the code simply works, since its initial release, for many years.

Perhaps; but consider Okajima-san's rationale, "Aufs2 is a refined
version of old aufs1: - to be reviewed easily and widely. - to make the
source files simpler and smaller by dropping several original
features."  Do note assume the code being proposed is the same as, or of
the same quality as, that from AUFS1.


If we really believe in choice, then unless AUFS2 obviously breaks
things, it's hard to argue against it's inclusion.  Thus can
best-of-breed emerge.
