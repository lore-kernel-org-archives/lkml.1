Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYLZVuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYLZVuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYLZVuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:50:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbYLZVuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:50:12 -0500
Message-ID: <49555179.6010300@zytor.com>
Date: Fri, 26 Dec 2008 13:49:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: SD/MMC cards: how crappy they are?
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com> <20081202165608.GD18162@mit.edu> <4935778E.1020405@zytor.com> <20081204103206.GD22396@elf.ucw.cz> <49382973.4000908@zytor.com> <20081226214625.GA25153@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081226214625.GA25153@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> Also had a batch of cards which would silently "correct" the partition
>> table for you to align the partitions to its flash erase blocks.
> 
> Can you mention the manufacturer/model? Silendt data corruption is a
> nasty thing....

I would, if I remembered.  It was a few years ago.  All I can remember
now is that it wasn't one of the well-known brands like SanDisk or PQI.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

