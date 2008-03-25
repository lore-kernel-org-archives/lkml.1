Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbYCYRyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbYCYRyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYCYRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:54:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46485 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbYCYRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:54:06 -0400
Date: Tue, 25 Mar 2008 18:57:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wander Winkelhorst <w.winkelhorst@gmail.com>
Cc: Michael Meyer <mike65134@yahoo.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
Message-ID: <20080325175716.GW2170@one.firstfloor.org>
References: <87abkmhgg0.fsf@basil.nowhere.org> <57127.43039.qm@web25812.mail.ukl.yahoo.com> <5699f8f00803251049s1823098u86b5431eadad2917@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5699f8f00803251049s1823098u86b5431eadad2917@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What kind of CPU are you using? Some Intel CPU's do "funny stuff",
> like dynamically overclocking itself when working on a single thread,
> or using all of the 2nd level cache instead of sharing it with the
> second core.

P0 should also work fine with cpu hotplug. At least in theory.

-Andi
