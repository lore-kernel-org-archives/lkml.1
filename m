Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYFCKFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYFCKFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYFCKFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:05:03 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:48055 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYFCKFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:05:01 -0400
Message-ID: <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
In-Reply-To: <20080603095713.GR28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
    <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
    <20080603095713.GR28946@ZenIV.linux.org.uk>
Date: Tue, 3 Jun 2008 12:04:42 +0200 (CEST)
Subject: Re: Linux 2.6.26-rc4
From: "Jesper Krogh" <jesper@krogh.cc>
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Cc: "Jesper Krogh" <jesper@krogh.cc>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1 [CVS]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Jun 03, 2008 at 11:49:32AM +0200, Jesper Krogh wrote:
>
>
>> I reported it to the NFS-guys on a .22 kernel, and was directed to the
>> fsdevel list(CC'ed again) back then. Now the problem is reproduced on
>> .26-rc4
>>
>
> Lovely...  Do you have the full oops trace, with the actual code
> dump? --

This is all I got from the logs. I'll try go get more from the serial
console.
But since it is not directly reproducible, it is a bit hard. Suggestions are
welcome?

Jesper
-- 
Jesper Krogh

