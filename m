Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbXFAIoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbXFAIoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXFAIoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:44:09 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:42190 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXFAIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:44:08 -0400
Message-ID: <465FDC57.6000800@alcatel-lucent.com>
Date: Fri, 01 Jun 2007 16:44:07 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to access kdb explicitly
References: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com> <465FC9FD.7060202@alcatel-lucent.com> <Pine.LNX.4.64.0706011042320.29896@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0706011042320.29896@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jun 2007 08:43:13.0674 (UTC) FILETIME=[E426BEA0:01C7A428]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 1 Jun 2007, gshan wrote:
>
>   
>> I want to access kdb explicitly. For example, I could recognize the 
>> special characters inside console driver. If the the special characters 
>> are detected , then drop to kdb immediately. However, I don't know what 
>> should I to do after the special characters received.
>>     
>
> See http://www.ibm.com/developerworks/linux/library/l-kdbug/ - section 
> "Activating KDB".
>
>   
Thanks a lot :-)
