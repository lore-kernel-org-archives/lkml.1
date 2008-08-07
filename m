Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYHGO7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYHGO7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYHGO7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:59:13 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:32864 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYHGO7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:59:12 -0400
Message-ID: <489B0DB1.30407@nortel.com>
Date: Thu, 07 Aug 2008 08:58:57 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100139.8625.7.camel@twins> <1218105242.15342.184.camel@think.oraclecorp.com>
In-Reply-To: <1218105242.15342.184.camel@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2008 14:59:00.0974 (UTC) FILETIME=[204170E0:01C8F89E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:

> I haven't done any real single cpu testing, it may make sense in those
> workloads to checksum and submit directly in the calling context.  But
> real single cpu boxes are harder to come by these days.

They're still pretty common in the embedded/low power space.  I could 
see something like a settop box wanting to use btrfs with massive disks.

Chris
