Return-Path: <linux-kernel-owner+w=401wt.eu-S944709AbXHMQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944709AbXHMQld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXHMPrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:47:05 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4887 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968379AbXHMPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:47:01 -0400
Message-ID: <46C07CEF.1020207@xs4all.nl>
Date: Mon, 13 Aug 2007 17:46:55 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: possible BUG while using CUPS
References: <46BD762F.4060801@xs4all.nl> <6bffcb0e0708130839v27b4269dqfde702c410b33fd0@mail.gmail.com>
In-Reply-To: <6bffcb0e0708130839v27b4269dqfde702c410b33fd0@mail.gmail.com>
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> On 11/08/07, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>> Using Cups 1.2.12 on Linux 2.6.22.1.
(...)
>> I clikc that link and hear the ping-ping of the BUG:
> 
> This is very interesting. Can you reproduce this bug?

I think so. (at least: I have seen it before: clicking around in Cups
and this crash/bug/whatever.)

>> This is on a VIA Epia EK8000. ksymoops did not really help me, this is
>> all output I got.
>>
>> Ideas?
> 
> BTW. Please try 2.6.22.2.

Compiling...
