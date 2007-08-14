Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbXHNPVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbXHNPVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXHNPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:21:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbXHNPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:21:30 -0400
Message-ID: <46C1C871.5020803@redhat.com>
Date: Tue, 14 Aug 2007 11:21:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: possible BUG while using CUPS
References: <46BD762F.4060801@xs4all.nl> <6bffcb0e0708130839v27b4269dqfde702c410b33fd0@mail.gmail.com> <46C07CEF.1020207@xs4all.nl>
In-Reply-To: <46C07CEF.1020207@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2007 11:46 AM, Udo van den Heuvel wrote:
> Michal Piotrowski wrote:
>> On 11/08/07, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>>> Using Cups 1.2.12 on Linux 2.6.22.1.
> (...)
>>> I clikc that link and hear the ping-ping of the BUG:
>> This is very interesting. Can you reproduce this bug?
> 
> I think so. (at least: I have seen it before: clicking around in Cups
> and this crash/bug/whatever.)
> 
>>> This is on a VIA Epia EK8000. ksymoops did not really help me, this is
>>> all output I got.
>>>
>>> Ideas?
>> BTW. Please try 2.6.22.2.
> 
> Compiling...

If you can reproduce that, do it after booting with "kstack=2048" and post
that so we can see the whole stack in the oops message.
