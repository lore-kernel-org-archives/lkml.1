Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZGUNjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZGUNjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 09:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZGUNjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 09:39:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:52057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZGUNjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 09:39:51 -0400
Message-ID: <4A65C50F.6090605@kernel.org>
Date: Tue, 21 Jul 2009 22:39:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: jens.axboe@oracle.com, Hannes Reinecke <hare@suse.de>,
       linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [RESEND][PATCH] Send uevents for disk write_protect changes
References: <200907211128.07252.knikanth@suse.de>
In-Reply-To: <200907211128.07252.knikanth@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 13:39:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan wrote:
> Hi
> 
> This patch is needed for the dm-multipath, so that the daemon can capture the 
> event and reload the dm table when the read-only setting of the disk changes. 
> Can this be merged?

This is for the next merge window, right?

Thanks.

-- 
tejun
