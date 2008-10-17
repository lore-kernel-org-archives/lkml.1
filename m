Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYJQBxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYJQBxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYJQBxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:53:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9472 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJQBxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XJ8qyJGK9MwKjoV6KaR2RI6xOjWBvMjQ4UL+44wBWNLggvA2TGVyQ+fAFz3AE5i0nb
         Bfnl72MxesnpXLm65u75lLIKHaKdHd7TafEjLbMmEjBXyt1ADnMPMPB1JO+lgBsIdtiI
         zCIvT9iM2aNZu1qKw35Mhz96xeQrm760wPdEY=
Message-ID: <a8e1da0810161853m3bbd8c1hf7c2ed5adf4cc4d6@mail.gmail.com>
Date: Fri, 17 Oct 2008 09:53:04 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <20081016153512.GE12962@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081016002509.GA25868@kroah.com>
	 <20081016142619.GA3756@tatooine.rebelbase.local>
	 <20081016153512.GE12962@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:35 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Oct 16, 2008 at 04:26:19PM +0200, markus reichelt wrote:
>> Why not just keep it? It has worked so far, and from a strictly
>> end-user point of view I cannot see any advantages at all with a new
>> scheme. The ideas mentioned so far don't cut it either.
>
> I'd cast a vote for keeping it as well.  "2.6" is actually a great
> marker so that people know that it's highly likely the version number
> is for the Linux kernel.  Contrast "I'm running 2.6.27" versus "I'm
> running 27" (huh, what does that mean?) or "I'm running the 27 kernel"
> or "I'm running Linux kernel version 27" or worse yet "I'm running
> 2008-03".  Something like "2.6.27" is just easier to say, and less
> prone to misunderstanding/confusion.
>
> Let's just leave things the way they are.

Agree.

Additionally, we can add some range to x.y.z

such as:

x: 1-9
y: 1-9
z: 1-30

so we can jumo to 2.7.1 after 2.6.30

-- 
Regards
dave
