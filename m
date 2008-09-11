Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbYIKPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbYIKPus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYIKPul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:50:41 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:26321 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYIKPuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:50:40 -0400
From: Frans Pop <elendil@planet.nl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
Date: Thu, 11 Sep 2008 17:49:38 +0200
User-Agent: KMail/1.9.9
Cc: davem@davemloft.net, jeffm@suse.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
References: <48C68507.6000609@suse.com> <200809111725.01511.elendil@planet.nl> <1221147068.8593.31.camel@macbook.infradead.org>
In-Reply-To: <1221147068.8593.31.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809111749.40204.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2008 15:49:40.0729 (UTC) FILETIME=[008C7E90:01C91426]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008, David Woodhouse wrote:
> On Thu, 2008-09-11 at 17:24 +0200, Frans Pop wrote:
> > Did you read the second part of the mail explaining why having a
> > single "firmware" package is not a good idea?
>
> Yes, but it was nonsense, so I ignored it. "The reason for this is the
> possibility that a driver and its firmware may be dropped from the
> upstream kernel source." That doesn't happen very often, and you
> _certainly_ don't need to immediately drop the firmware if it does.

Fine. Again you are concentrating on the bright and shiny future and 
magically wishing into existence tools to support the new situation.

Just keep on ignoring current issues. As I've said, I can work around 
them. However, I seriously expect others will have stopped their kernel 
testing and I also expect "real users" to run into problems building 
custom kernels.

I think I've made my point and will (try to) keep out of the discussion. 
It's way too much like discussing religion anyway: people who "believe" 
are rarely able to listen properly.
