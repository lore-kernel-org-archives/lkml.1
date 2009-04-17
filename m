Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbZDQXNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbZDQXNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762431AbZDQXM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:12:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:19174 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762399AbZDQXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:12:56 -0400
X-IronPort-AV: E=Sophos;i="4.40,206,1238976000"; 
   d="scan'208";a="288388267"
Date: Fri, 17 Apr 2009 16:12:53 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-ID: <20090417231253.GA8449@cuplxvomd02.corp.sa.net>
References: <20090417213148.GA27825@cuplxvomd02.corp.sa.net> <49E8FF80.1020901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E8FF80.1020901@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 03:15:28PM -0700, H. Peter Anvin wrote:
> David VomLehn wrote:
>>>  
>> +	consoledelay=mS	[KNL] Wait up to mS milliseconds for the a preferred
>> +			console to be registered, then continue. Useful for
>> +			systems where a console may not be plugged in, such as
>> +			for USB serial devices.
>> +
>
> Pet peeve:
>
> The symbol for millisecond is "ms".  mS is a unit of conductance,  
> millisiemens.

Thanks for the info; this stuff does matter.
