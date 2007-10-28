Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbXJ1QHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbXJ1QHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXJ1QHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:07:33 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:44329 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXJ1QHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:07:33 -0400
Message-ID: <4724B3BD.1010509@tiscali.nl>
Date: Sun, 28 Oct 2007 17:07:25 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Debugging activated during runtime
References: <4724A783.9050400@tiscali.nl> <Pine.LNX.4.64.0710281618520.30465@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710281618520.30465@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 28 2007 16:15, Roel Kluin wrote:
>> Wouldn't it be nice to be able to specify upon loading, or during runtime
>> to modules whether debug messages should be printed?
> 
> modprobe ark3116 debug=1
> 
> Nothing new.

Ok, thanks and sorry, I didn't know that.

>> - A module could be loaded after an unexpected conditions (e.g. after a BUG_ON).
> 
> After a BUG_ON, you are probably next to a panic.

Not always, it appears.
