Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbXGIXJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbXGIXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 19:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXGIXJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 19:09:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33211 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760702AbXGIXJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 19:09:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4692C031.1090503@s5r6.in-berlin.de>
Date: Tue, 10 Jul 2007 01:09:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Make profiling uniformly non-menu and non-EXPERIMENTAL.
References: <Pine.LNX.4.64.0707090357580.21984@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707090357580.21984@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> 2) given how long profiling has been around, it's just as pointless to
> keep categorizing it as EXPERIMENTAL, so drop all EXPERIMENTAL labels
> and dependencies.

Only because something has been around for a while, even for years, it
doesn't automatically loose "experimental" status.  It does when it has
been extensively and successfully debugged, verified and tested, and no
reservations regarding run-time stability or userspace interface
stability remain.  Is this true for these profiling options?
-- 
Stefan Richter
-=====-=-=== -=== -=-=-
http://arcgraph.de/sr/
