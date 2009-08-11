Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbZHKC1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbZHKC1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 22:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZHKC1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 22:27:00 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48517 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZHKC07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 22:26:59 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=n734oir6eZo1qU3a57sL7A==:17 a=7t9U9tpv3E00FKhP1foA:9
 a=T6F30QoRrWfrHxFBPpZP0WxNjRYA:4
Message-ID: <4A80D6D4.3080005@ubb.ca>
Date: Mon, 10 Aug 2009 19:26:28 -0700
From: Tony Mantler <nicoya@ubb.ca>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: case-duplicated filenames
References: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca> <4A80D5DF.3090402@davidnewall.com>
In-Reply-To: <4A80D5DF.3090402@davidnewall.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Tony Mantler wrote:
>> A co-worker reminded me this afternoon that the linux source tree does not
>> get along well with case-insensitive filesystems. Ever the curious and
>> bored sort, and in the middle of an sqlite bender, I decided to cook up a
>> quick script to find exactly what files those are.
>>   
> 
> Such an extravagant process: you're just being silly.

Well I did say I was bored. ;)


 > There appears to be a line missing:
> 
> find $DIRECTORY | sed 's/^\(.*\)/INSERT INTO filenames (name) VALUES ("\1");/' >>$SQLFILE

?

