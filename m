Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYFZM07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYFZM07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYFZM0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:26:51 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4117 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYFZM0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:26:51 -0400
Date: Thu, 26 Jun 2008 14:26:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What's in linux-2.6-block.git for 2.6.27
Message-ID: <20080626122648.GU20851@kernel.dk>
References: <20080626115404.GS20851@kernel.dk> <6101e8c40806260522u44eff375l8cd02b0f0931e9a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40806260522u44eff375l8cd02b0f0931e9a8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26 2008, Oliver Pinter wrote:
> Hi Jens!
> 
> this:  - Write starvation fix for 'AS', a very long standing bug for
> 2.6.26 is to big change?

Probably not, but since this bug has existed for years with very little
impact, it's not critical enough to warrant direct inclusion. Thus, it's
queued up with the rest of the changes for the next release.

-- 
Jens Axboe

