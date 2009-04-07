Return-Path: <linux-kernel-owner+w=401wt.eu-S1751316AbZDGEEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbZDGEEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZDGEEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:04:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46261
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbZDGEEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:04:37 -0400
Date: Mon, 06 Apr 2009 21:04:26 -0700 (PDT)
Message-Id: <20090406.210426.38766000.davem@davemloft.net>
To: jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090406202441.1c050ec6@hobbes>
References: <20090406.190745.263215778.davem@davemloft.net>
	<alpine.LFD.2.00.0904061931160.4010@localhost.localdomain>
	<20090406202441.1c050ec6@hobbes>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 6 Apr 2009 20:24:41 -0700

> On Mon, 6 Apr 2009 19:32:11 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Mon, 6 Apr 2009, David Miller wrote:
>> 
>> > From: Linus Torvalds <torvalds@linux-foundation.org>
>> > Date: Mon, 6 Apr 2009 18:25:31 -0700 (PDT)
>> > > 
>> > > 
>> > > The sky2 driver is buggered (by the previous pull, I presume).
>> > > Some PCI interaction. NULL pointer dereference at boot.
>> > 
>> > Fixed in the PCI tree, have you pulled that one yet?
>> 
>> Nobody has even _asked_ me to pull.
>> 
>> What's the point of having fixes available if they aren't merged?
> 
> I just pushed it into my repo today and wanted at least a day of
> linux-next before asking you to pull.

I feel like I've been watching people get pointed to that fix
for what seems like days.

In fact this is why I was under the impression that you had
already asked Linus to merge the fix. :-)

