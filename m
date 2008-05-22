Return-Path: <linux-kernel-owner+w=401wt.eu-S936583AbYEVKW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936583AbYEVKW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936469AbYEVKVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:21:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59272 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936456AbYEVKVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:21:18 -0400
Message-ID: <4835491A.1020209@garzik.org>
Date: Thu, 22 May 2008 06:21:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 1/4] Restore multicast settings on resume
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080518130035.GA21417@yamamaya.is-a-geek.org>
In-Reply-To: <20080518130035.GA21417@yamamaya.is-a-geek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> 
> nv_open() resets multicast settings, call nv_set_multicast(dev) to restore them.
> (Maybe this should rather be moved into nv_open())
> 
> Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>

applied

Ayaz, have you reviewed the other patches in this series?


