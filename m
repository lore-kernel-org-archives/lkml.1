Return-Path: <linux-kernel-owner+w=401wt.eu-S936411AbXJQCpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936411AbXJQCpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761926AbXJQCpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:45:21 -0400
Received: from fencepost.gnu.org ([140.186.70.10]:49791 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbXJQCpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:45:20 -0400
Subject: Re: Distinguishing releases from pre-rc snapshots
From: Pavel Roskin <proski@gnu.org>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071017023406.GA3397@redhat.com>
References: <1192587763.3672.24.camel@dv> <20071017023406.GA3397@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Oct 2007 22:45:17 -0400
Message-Id: <1192589117.3672.31.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-2.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-16 at 22:34 -0400, Dave Jones wrote:
> On Tue, Oct 16, 2007 at 10:22:43PM -0400, Pavel Roskin wrote:
> 
>  > It would be nice to establish a rule to increment the version number
>  > immediately after the kernel release and have a suffix to indicate that
>  > it's a pre-rc version.  "rc0" is my personal favorite.
> 
> fwiw, rc0 is also what the Fedora kernel uses for versioning when we're
> shipping pre-rc1 kernels.

Thanks!  I didn't think of the possibility of anyone distributing
precompiled kernels from the "pre-rc" window, but if Fedora does it
(hopefully for beta-testers only), it should be absolutely clear that
it's not just a release with some minor fixes.

Anyone adjusting any software for that kernel would be adjusting for the
next kernel release.

-- 
Regards,
Pavel Roskin

