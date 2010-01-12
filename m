Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790Ab0ALRNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0ALRNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895Ab0ALRNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:13:37 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:59764 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0ALRNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:13:36 -0500
Message-ID: <4B4CADAB.5090607@gmail.com>
Date: Tue, 12 Jan 2010 12:13:15 -0500
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Clark Williams <williams@redhat.com>
CC: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
References: <20100106130400.7f30ae55@torg>	<1263315590.374.6.camel@sven.thebigcorporation.com> <20100112110453.4589d05e@torg>
In-Reply-To: <20100112110453.4589d05e@torg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 12:04 PM, Clark Williams wrote:
> On Tue, 12 Jan 2010 11:59:50 -0500
> Sven-Thorsten Dietrich <thebigcorporation@gmail.com> wrote:
>
>   
>> On Wed, 2010-01-06 at 13:04 -0600, Clark Williams wrote:
>>     
>>> RT-ers,
>>>       
>> Hi Clark,
>>
>> sorry to be late to this, I have been out on a sailboat in the Bahamas.
>>
>> When using the histogram feature, cyclictest already behaves the way you
>> describe below.
>>
>> Sven
>>
>>     
> Yeah I know, but sometimes I don't want to have to deal with the
> histogram...
>   

Absolutely, just pointing out that at least some of the logic is in there.

I think that decoupling that functionality, and making it implicit for
histogram would be a good thing and not very hard.

Sven
