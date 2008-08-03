Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYHCBdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYHCBdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 21:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYHCBdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 21:33:37 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:37544 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751516AbYHCBdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 21:33:36 -0400
Message-ID: <48950AEB.9060700@gawab.com>
Date: Sat, 02 Aug 2008 18:33:31 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: jasper@amiton.co.nz, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc1] Can't connect to encrypted network
References: <4893DC52.9060203@gawab.com> <200808021641.02487.rjw@sisk.pl>
In-Reply-To: <200808021641.02487.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 2 of August 2008, Justin Madru wrote:
>   
>> Hi,
>>
>> When I use the 2.6.27-rc1 kernel I can't connect to an encrypted 
>> network; the connection times out. Connecting to unencrypted works fine.
>> If I use my distro's kernel (2.6.24) or my build 2.6.26 kernel it is 
>> able to connect. I'm using Ubuntu 8.4 and an intel 3945 card.
>> Am I doing something wrong? or is this a regression? I get the following 
>> in my syslog:
>>
>> [[snip]]
>>     
>
> Please test the current -git (2.6.27-rc1-git4 as of today).
>
> Thanks,
> Rafael

Ok, tested current -git and I was able to connect to the encrypted network.
So, I'm happy :-) ! And 2.6.27 has even fixed a regression I was having 
with 2.6.{25,26}.

Justin Madru
