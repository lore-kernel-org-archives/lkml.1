Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbXITJNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbXITJNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbXITJLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:11:32 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4574 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbXITJLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:11:14 -0400
Date: Thu, 20 Sep 2007 10:10:42 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Michael Opdenacker <michael@free-electrons.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-tiny <Linux-tiny@selenic.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>
Subject: Re: [Celinux-dev] [Announce] Linux-tiny project revival
Message-ID: <20070920091042.GA6035@shadowen.org>
References: <46F1645D.9050406@am.sony.com> <20070919142805.e0242fcf.akpm@linux-foundation.org> <46F19778.7000408@am.sony.com> <46F1A4FF.6040808@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F1A4FF.6040808@free-electrons.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 12:38:55AM +0200, Michael Opdenacker wrote:

> Andrew, you're completely right... The patches should all aim at being
> included into mainline or die.
> 
> I'm finishing a sequence of crazy weeks and I will have time to send you
> patches one by one next week, starting with the easiest ones.

Well thats good news.  In response to the comments made about testing
the impact of these patches on big-iron I was going to suggest we ask
Andrew to include your patch set in -mm so that it firstly gets at least
compiled on big-iron, and secondly so we could think about how to test
with some of the options enabled on big-iron.

Knowing nothing about these options, from a test perspective it would
be nice if we were able to simply enable "the lot" so we can do "normal"
-mm runs and "tiny" -mm runs without any manual intervention?

-apw
