Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0BGXLG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 18:11:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:58871 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756442Ab0BGXLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:11:02 -0500
X-Authenticated: #54312696
X-Provags-ID: V01U2FsdGVkX1/lKoEl6BnlnrEl8wlNilPBuB0z+4U3FiMn5pzCJV
	VcEcicaGQCCg0d
Date: Mon, 08 Feb 2010 00:11:02 +0100 (CET)
Message-Id: <20100208.001102.25410141.wl@gnu.org>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Bug #15158] oops related to
 i915_gem_object_save_bit_17_swizzle
From: Werner LEMBERG <wl@gnu.org>
In-Reply-To: <de962C6zBxL.A.wzD.9EiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	<de962C6zBxL.A.wzD.9EiZLB@chimera>
X-Mailer: Mew version 6.2.53 on Emacs 23.1.50.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15158
> Subject		: oops related to i915_gem_object_save_bit_17_swizzle
> Submitter	: Werner Lemberg <wl@gnu.org>
> Date		: 2010-01-28 08:26 (4 days old)

I've just experienced the crash again, this time with openSuSE kernel
2.6.33-rc6-11-pae and xorg-x11-driver-video-7.4-245.1


    Werner
