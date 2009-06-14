Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbZFNKss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbZFNKss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbZFNKsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:48:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60707 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbZFNKsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:48:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Jun 2009 12:48:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What's in linux1394-2.6.git?
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.70eb865eb2fae29b@s5r6.in-berlin.de>
Message-ID: <tkrat.92466f507d376cc5@s5r6.in-berlin.de>
References: <tkrat.70eb865eb2fae29b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Batch 2: for-linus..for-next
> ============================
> 
> This contains Jay Fenlason's IPv4-over-1394 driver,

A note to those who pulled linux1394-2.6.git's "net" branch in the last
few days:  I deleted this branch, and for-next is not an ancestor of it
requeued the IPv4 patches to after the latest firewire-core updates.
-- 
Stefan Richter
-=====-==--= -==- -===-
http://arcgraph.de/sr/

