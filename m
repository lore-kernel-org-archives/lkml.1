Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYKRWcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYKRWcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKRWce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:32:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:40739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYKRWcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:32:33 -0500
Date: Tue, 18 Nov 2008 23:32:29 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: thomas.mingarelli@hp.com, linux-kernel@vger.kernel.org, wim@iguana.be,
       stable@kernel.org
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as
 executable
Message-ID: <20081118233229.294270fb@kopernikus.site>
In-Reply-To: <20081118143015.72af31d3.akpm@linux-foundation.org>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de>
	<20081118143015.72af31d3.akpm@linux-foundation.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton [2008-11-18 14:30]:
>
> This is also needed in 2.6.27.x, yes?

Right. But I was waiting for feedback from the author since I'm really
not familiar with low level memory management and that driver. :(


Regards,
Bernhard
