Return-Path: <linux-kernel-owner+w=401wt.eu-S1765425AbXILUp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765425AbXILUp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbXILUpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:45:17 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:38143 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbXILUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:45:16 -0400
Message-ID: <46E84FD0.8070606@nortel.com>
Date: Wed, 12 Sep 2007 14:45:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: linux-kernel@vger.kernel.org, manfred@colorfullife.com
Subject: Re: OOPS in __copy_user_zeroing_intel
References: <46E6B797.8050605@nortel.com> <6bffcb0e0709120854m69878efav8d6f3d638e82c890@mail.gmail.com>
In-Reply-To: <6bffcb0e0709120854m69878efav8d6f3d638e82c890@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2007 20:45:07.0982 (UTC) FILETIME=[CE09E2E0:01C7F57D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:

> On 11/09/2007, Chris Friesen <cfriesen@nortel.com> wrote:

>>We're running a modified 2.6.10 on a dual-Xeon system.

> Eh, this is a pretty ancient kernel.

Yes, it is.

> You may want to use one of the long time support kernel 2.6.16.x or 2.6.20.x.

I wish I could, but it's not an option.  This is an embedded product. 
Changing kernel versions takes literally months because it means new 
board support packages from hardware vendors, new drivers, and a whole 
new set of product validation tests.

Chris
