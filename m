Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941Ab0ARSwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0ARSwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889Ab0ARSwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:52:50 -0500
Received: from eazy.amigager.de ([213.239.192.238]:53441 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0ARSwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:52:49 -0500
Date: Mon, 18 Jan 2010 19:52:45 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: Mike McCormack <mikem@ring3k.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Regression: Wake on LAN doesn't work in sky2 with
 2.6.33-rc4-git2
Message-ID: <20100118185245.GA3750@mac.home>
Mail-Followup-To: Mike McCormack <mikem@ring3k.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
References: <20100115091053.GA5477@mac.home>
 <201001152323.37718.rjw@sisk.pl>
 <20100117231932.GA5504@mac.home>
 <201001180136.45823.rjw@sisk.pl>
 <20100118083757.GA2619@mac.home>
 <4B544D2C.8040400@ring3k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B544D2C.8040400@ring3k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 20:59:40 +0900, Mike McCormack wrote:
> Tino Keitel wrote:
> > Hi,
> > 
> > reverting this commit fixes WoL for me:
> > 
> > commit 166a0fd4c788ec7f10ca8194ec6d526afa12db75
> 
> Hi Tino,
> 
> Does this fix WoL also?  Compile tested only...

No, still no wakeup on WoL packets.

Regards,
Tino
