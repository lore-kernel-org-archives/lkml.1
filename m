Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZHXNkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZHXNkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 09:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZHXNkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 09:40:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:65496 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZHXNkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:40:13 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
       Nicolas Pitre <nico@cam.org>, linux-kernel@vger.kernel.org,
       linux-arm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: ARM subarch submissions for next merge window
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 24 Aug 2009 16:40:10 +0300
Message-ID: <877hwtnxdx.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

After some discussions on linux-arm-kernel during the last merge
window, a suggestion from Alan Cox[1], and a willingness to try it
from Russell[2], some ARM subarch maintainers would like to push our
platform-specific code directly to you for the next merge window.

Any changes that affect common ARM code will still be pushed via
Russell, only our platform-specific code will be submitted directly.

Also our platform code is still posted and reviewed on
linux-arm-kernel as well as being included in linux-next. Only the
merge path will change slightly.

Any problems with this?

Kevin
 maintainer: arch/arm/mach-davinci/*
 developer: arch/arm/mach-omap2/*

[1] http://marc.info/?l=linux-arm-kernel&m=124472557106678&w=2
[2] http://marc.info/?l=linux-kernel&m=124472614607233&w=2
