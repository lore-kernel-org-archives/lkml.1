Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbXCKAVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbXCKAVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 19:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXCKAVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 19:21:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbXCKAVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 19:21:13 -0500
Date: Sat, 10 Mar 2007 16:21:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@outflux.net>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-Id: <20070310162101.716b6b57.akpm@linux-foundation.org>
In-Reply-To: <20070310183341.GB10460@outflux.net>
References: <20070307012234.GN9621@outflux.net>
	<20070306175609.267bd7a9.akpm@linux-foundation.org>
	<20070307021335.GR9621@outflux.net>
	<20070306185942.585e7cd1.akpm@linux-foundation.org>
	<20070307031429.GU9621@outflux.net>
	<1173241331.3236.10.camel@laptopd505.fenrus.org>
	<20070308205525.GJ6805@outflux.net>
	<20070309183006.7ff23eff.akpm@linux-foundation.org>
	<45F23BB5.8090907@linux.intel.com>
	<20070310183341.GB10460@outflux.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 10 Mar 2007 10:33:41 -0800 Kees Cook <kees@outflux.net> wrote:
> Here's another revision, with both the "can ptrace" and the global /proc 
> knob;

We'd be needing a changelog for that.

Please update the procfs documentation.

Does the patch also cover /proc/pid/smaps?
