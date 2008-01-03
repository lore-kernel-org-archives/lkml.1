Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYACHXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYACHXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYACHXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:23:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33822 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYACHXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:23:33 -0500
Date: Thu, 3 Jan 2008 08:23:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH -mm] compat_binfmt_elf Kconfig
Message-ID: <20080103072334.GA16176@uranus.ravnborg.org>
References: <20071223183920.GA13976@elte.hu> <20071223211603.3FFB126F8E7@magilla.localdomain> <20071230163614.GB1384@elte.hu> <20080102044157.A5CC526F99F@magilla.localdomain> <20080102111431.GD14731@elte.hu> <20080102191030.GA11217@uranus.ravnborg.org> <20080102210831.9F80426F9A0@magilla.localdomain> <20080102215311.GA12558@uranus.ravnborg.org> <20080102221228.C9D8D26F9A0@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102221228.C9D8D26F9A0@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 02:12:28PM -0800, Roland McGrath wrote:
> I have no opinions about the config symbol names.  Among the existing
> precedents for internal/descriptionless symbols I find more not using the
> HAVE_ prefix than those using it.
The convention is newly established - so no suprise.

> The patch versions I've sent now work
> fine, fix the parallel build problem people were seeing, and AFAICT follow
> the style of what's already in common use.  At this point, I think it would
> be easiest just to keep them and have you send symbol-renaming patches
> for any and all symbols of this sort that concern you as separate cleanups.
Would love to - but the pile of other kbuild stuff only gets bigger..

	Sam
