Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXCKBzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXCKBzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 20:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932454AbXCKBzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 20:55:55 -0500
Received: from mylar.outflux.net ([69.93.193.226]:47993 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbXCKBzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 20:55:54 -0500
Date: Sat, 10 Mar 2007 17:55:47 -0800
From: Kees Cook <kees@outflux.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-ID: <20070311015547.GI10460@outflux.net>
References: <20070306175609.267bd7a9.akpm@linux-foundation.org> <20070307021335.GR9621@outflux.net> <20070306185942.585e7cd1.akpm@linux-foundation.org> <20070307031429.GU9621@outflux.net> <1173241331.3236.10.camel@laptopd505.fenrus.org> <20070308205525.GJ6805@outflux.net> <20070309183006.7ff23eff.akpm@linux-foundation.org> <45F23BB5.8090907@linux.intel.com> <20070310183341.GB10460@outflux.net> <20070310162101.716b6b57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310162101.716b6b57.akpm@linux-foundation.org>
Organization: Kernel.Org
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 04:21:01PM -0800, Andrew Morton wrote:
> We'd be needing a changelog for that.

Done; sent separately from this email.

> Please update the procfs documentation.

Done.

> Does the patch also cover /proc/pid/smaps?

Yes, and numa_maps.

Thanks!

-- 
Kees Cook
