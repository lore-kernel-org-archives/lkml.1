Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYGUW33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYGUW33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYGUW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:29:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37547 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYGUW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:29:20 -0400
Date: Mon, 21 Jul 2008 23:29:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 0/0] Power domain and clock domain patches for omap
Message-ID: <20080721222908.GF18909@flint.arm.linux.org.uk>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216221555-18958-1-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 06:19:05PM +0300, Tony Lindgren wrote:
> I'm reposting the series to a wider audience as Russell King suspected that
> other archs may be interested in reviewing these too, or at least some
> parts of the code.

It would be nice to have some comment on these patches from other
people.  My suspicions is that this infrastructure is solving a
problem found on other SoCs in addition to OMAP, and, if this is
useful to other people, it should become cross-SoC infrastructure.

Since I don't know the answer to whether it would be useful, I'm
trying to ensure that these patches have sufficient exposure to
people who _may_ know the answer.
