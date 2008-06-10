Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYFJXjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYFJXjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYFJXj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:39:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbYFJXj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:39:26 -0400
Message-ID: <484F10A9.4030606@zytor.com>
Date: Tue, 10 Jun 2008 16:39:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: devzero@web.de
CC: keith@karsites.net, linux-kernel@vger.kernel.org
Subject: Re: Problems with edd
References: <311993399@web.de>
In-Reply-To: <311993399@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
>>
>> Loading vmlinuz........................................... 
>> ..............
>>
>>  Loading initrd.img........................................ 
>> .................
>>  ...............ready.
>>  Probing EDD (edd=off to disable)... ok
>>  vmlinuz: attempted DOS system call
>>  boot:
>>
>>  If I hit return now, the machine goes back to the 'Welcome 
>> to Fedora 9!' splash screen.
>>

I have put in syslinux 3.70-pre16 code to print the source of this 
message.  You may want to try to grab isolinux from this release and 
update your CD image to get some useful debugging info out of this.

	-hpa
