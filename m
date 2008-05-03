Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYECCVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYECCVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 22:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYECCVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 22:21:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYECCVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 22:21:03 -0400
Message-ID: <481BCC00.1030508@redhat.com>
Date: Fri, 02 May 2008 21:20:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       linux-kernel@vger.kernel.org, joern@lazybastard.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] fix checkstack.pl arch detection
References: <481B4D75.9060305@redhat.com>	<20080502223702.GI24080@logfs.org> <20080502164458.b703acf7.akpm@linux-foundation.org>
In-Reply-To: <20080502164458.b703acf7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 3 May 2008 00:37:03 +0200
> J__rn Engel <joern@logfs.org> wrote:
> 
>> On Fri, 2 May 2008 12:20:53 -0500, Eric Sandeen wrote:
>>> uname -m was leaving a newline in $arch, and not passing the tests.
>>>
>>> Also, printing the unknown arch on failure is probably helpful.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Reviewed-By: Joern Engel <joern@logfs.org>
>>
> 
> please cc apw on checkpatch changes.
> 
> This patch needs some help to merge against the forthcoming
> checkpatch-0.19.  I sent your patches apw-wards.
> 

Um, checkpatch or checkstack? :)

-Eric
