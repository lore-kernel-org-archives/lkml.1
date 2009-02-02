Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZBBPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZBBPQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZBBPP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:15:56 -0500
Received: from mail.embedromix.ro ([82.78.144.6]:49701 "EHLO
	mail.embedromix.ro" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbZBBPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:15:55 -0500
Date: Mon, 2 Feb 2009 17:15:40 +0200 (EET)
From: "Catalin(ux) M. BOIE" <catab@embedromix.ro>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Seagate disk freeze for 30 seconds then comes back (RecovComm
 10B8B)
In-Reply-To: <20090130212115.GB26062@csclub.uwaterloo.ca>
Message-ID: <alpine.LFD.2.00.0902021714430.5093@mail.embedromix.ro>
References: <alpine.LFD.2.00.0901271739400.2013@mail.embedromix.ro> <20090128153141.GC26064@csclub.uwaterloo.ca> <498244D4.4060903@tmr.com> <20090130212115.GB26062@csclub.uwaterloo.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Lennart Sorensen wrote:

> On Thu, Jan 29, 2009 at 07:07:48PM -0500, Bill Davidsen wrote:
>> Would you expect that firmware would be shared between old tech laptop
>> drives and desktop/server drives? Particularly since the laptop drive was
>> built before any of the 7200.11 drives?
>>
>> I think this is a very unlikely part of the problem. Certainly the drive
>> might be dying or other hardware issue.
>
> It does seem unlikely, although if it is a common design flaw in their
> firmware, it could have been carried over from older drives and just not
> be as noticeable on the older drives with smaller caches and less drive
> space.
>
> Now if the drive is really old, then year it might simply be failing.

No, the driver is pretty new (less than 1 year old) and the use is very 
light.

> -- 
> Len Sorensen
>

--
Catalin(ux) M. BOIE
http://kernel.embedromix.ro/
