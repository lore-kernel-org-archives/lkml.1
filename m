Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZAWSN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZAWSN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZAWSNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:13:49 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:43538 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZAWSNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:13:49 -0500
Message-ID: <497A0884.3010408@caviumnetworks.com>
Date: Fri, 23 Jan 2009 10:12:20 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Walrond <andrew@walrond.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
References: <497A0164.90409@walrond.org> <497A034F.6060303@caviumnetworks.com> <497A06CE.9040901@walrond.org>
In-Reply-To: <497A06CE.9040901@walrond.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2009 18:12:20.0462 (UTC) FILETIME=[21E698E0:01C97D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Walrond wrote:
> David Daney wrote:
>> You do have to have your kernel configured properly for a serial 
>> console for it to work right.
>>
> Sorry to be blunt, but I don't think you read my message very carefully! 

I did, I read every word of it.  I am sorry I was not specific enough 
for you.  I really meant to ask:

Do you have: CONFIG_SERIAL_8250_CONSOLE=y


David Daney.
