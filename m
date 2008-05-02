Return-Path: <linux-kernel-owner+w=401wt.eu-S937414AbYEBXQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937414AbYEBXQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932573AbYEBXQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:16:08 -0400
Received: from smtp.enter.net ([216.193.128.24]:4444 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535AbYEBXQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:16:07 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
Date: Fri, 2 May 2008 19:15:37 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com> <82e4877d0805021030s793835a1le0032673b0f4c6c7@mail.gmail.com> <20080502180151.GD5838@cs181133002.pp.htv.fi>
In-Reply-To: <20080502180151.GD5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021915.37480.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008 14:01:51 Adrian Bunk wrote:
> On Fri, May 02, 2008 at 01:30:23PM -0400, Parag Warudkar wrote:
> > On Fri, May 2, 2008 at 12:29 PM, Daniel Hazelton <dhazelton@enter.net>
> > wrote: This is what Adrian was pointing
<snip>
>
> From what I forwarded it's clear that we have a bug somewhere in the
> kernel.
>
> And the maintainer might well be right that it's not in his driver.

This is something that can't be known without enough information from the 
person reporting the bug. From what you posted of the bugzilla entry it's 
unclear whether the reporter did post more than his simple description or 
not.

However, the point is well made and I, at least, agree. (whatever that may be 
worth - I've never managed to finish a patch for anything without seeing the 
equivalent show up here later)

> Which means to reassign the bug to the maintainer of the area this bug
> is in.

Yep. Closing it with a comment of "broken hardware" is an incorrect response. 
Doubly or trebly so if the bugzilla entry didn't contain enough information 
to even determine whether the bug was in the driver or not.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
