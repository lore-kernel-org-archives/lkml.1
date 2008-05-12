Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYELThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYELThW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYELThL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbYELThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:37:09 -0400
Message-ID: <48289C59.5040401@zytor.com>
Date: Mon, 12 May 2008 12:36:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Oliver Hartkopp <oliver@hartkopp.net>
CC: Romano Giannetti <romanol@upcomillas.es>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>	 <48198873.7030503@hartkopp.net>  <481A06C0.6070500@zytor.com> <1210163964.14371.1.camel@localhost> <48282C69.2070006@hartkopp.net> <48286364.7010107@zytor.com> <48288E4E.3080107@hartkopp.net>
In-Reply-To: <48288E4E.3080107@hartkopp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Hartkopp wrote:
> H. Peter Anvin wrote:
>> Oliver Hartkopp wrote:
>>>
>>> Yes - this was also my intention. I don't have any preferences if the 
>>> first commit after a release is named -merge or -rc0. But it should 
>>> point out that we're leaving the former stable release.
>>>
>>
>> Either way it'll take a bunch of work.
> 
> Can you give any details?
> 
> Why does tagging a -rc0 create any effort for anyone - except half a 
> minute for Linus?
> 

Because it breaks all the robots which rely on the kernel naming scheme.

Again.

You already asked.

	-hpa
