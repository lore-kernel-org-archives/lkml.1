Return-Path: <linux-kernel-owner+w=401wt.eu-S1030285AbXCFSvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbXCFSvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030300AbXCFSva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:51:30 -0500
Received: from terminus.zytor.com ([192.83.249.54]:59822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030297AbXCFSv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:51:28 -0500
Message-ID: <45EDB7EB.6090500@zytor.com>
Date: Tue, 06 Mar 2007 10:50:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
References: <20070223170527.4ca695b2@freekitty> <20070305155714.3abe1b5e@freekitty> <20070306133404.GA864@one.firstfloor.org> <200703061519.20346.dada1@cosmosbay.com> <20070306144529.GA2004@one.firstfloor.org>
In-Reply-To: <20070306144529.GA2004@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> <rant>
>> Let me see... You throw code like that and expect someone to actually 
>> understand it in one year, and be able to correct a bug ?
> 
> To be honest I don't expect any bugs in this function.
> 
>> </rant>
>>
>> Please add something, an URL or even better a nice explanation, per favor...
> 
> It's straight out of Hacker's delight which is referenced in the commit
> log.

Referencing it in a comment would have been a better idea.

	-hpa
