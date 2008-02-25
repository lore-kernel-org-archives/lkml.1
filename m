Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYBYIPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYBYIPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYBYIP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:15:28 -0500
Received: from mail.hevs.ch ([153.109.23.10]:55482 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbYBYIP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:15:27 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] atmel_spi: support zero length transfer
Date: Mon, 25 Feb 2008 09:15:36 +0100
User-Agent: KMail/1.9.7
Cc: anemo@mba.ocn.ne.jp, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp> <200802221030.32263.marc.pignat@hevs.ch> <200802221855.25892.david-b@pacbell.net>
In-Reply-To: <200802221855.25892.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802250915.37384.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008, David Brownell wrote:
...
> No, it's fully defined.  "Crash my engine" is not OK.  The delay
> is controlled by transfer.delay_usecs ... possibly zero, which is
> best viewed as a degenerate case.
Ooops, I missed that (the delay *is* defined in transfer.delay_usecs).
So I agree, it's fully defined.

Regards

Marc
