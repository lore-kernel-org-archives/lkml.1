Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZKWWAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZKWWAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbZKWWAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:00:41 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52260 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbZKWWAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:00:38 -0500
Date: Mon, 23 Nov 2009 16:33:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       Bob Copeland <me@bobcopeland.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [Resend][PATCH] Wireless / ath5k: Simplify suspend and resume
	callbacks
Message-ID: <20091123213353.GA9045@tuxdriver.com>
References: <200911212344.24170.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911212344.24170.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 11:44:24PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Wireless / ath5k: Simplify suspend and resume callbacks
> 
> Simplify the suspend and resume callbacks of ath5k by converting the
> driver to struct dev_pm_ops and allowing the PCI PM core to do the
> PCI-specific suspend/resume handling.
> 
> Tested with Atheros Communications Inc. AR2413 802.11bg NIC (rev 01)
> D-Link CardBus.adapter.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

This is already queued for -next.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
