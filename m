Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbXIXXJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbXIXXJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbXIXXJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:09:43 -0400
Received: from tim.rpsys.net ([194.106.48.114]:52809 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbXIXXJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:09:42 -0400
Subject: Re: [PATCH] leds: add missing header
From: Richard Purdie <rpurdie@rpsys.net>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070923081408.312e02c3@poseidon.drzeus.cx>
References: <20070923081408.312e02c3@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 00:09:12 +0100
Message-Id: <1190675352.19359.122.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 08:14 +0200, Pierre Ossman wrote:
> rwlocks are used in the structures so make sure the right header
> is included.
> 
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

I think something similar was already committed in revision
df96efd73b81b8bc2d23b3d8b6025cce3d43db6c.

Cheers,

Richard


