Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664Ab0AITr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0AITr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 14:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948Ab0AITrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 14:47:55 -0500
Received: from ms01.sssup.it ([193.205.80.99]:33640 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380Ab0AITrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 14:47:55 -0500
Message-ID: <4B48DD61.2060401@gandalf.sssup.it>
Date: Sat, 09 Jan 2010 20:47:45 +0100
From: Michael Trimarchi <trimarchi@gandalf.sssup.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: "Paul G. Allen" <pgallen@gmail.com>
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Serial Performance
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com>	 <20100109191025.GK4757@const.famille.thibault.fr> <bd8e30a41001091132m611a2054i3ed4098111e005cb@mail.gmail.com>
In-Reply-To: <bd8e30a41001091132m611a2054i3ed4098111e005cb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul G. Allen wrote:
> Well, as far as I know. Same code on both systems. The embedded device
> operates at 115200, 8N1, no flow control. It uses RPC/SLIP protocol
> for commands and data. They talk to each other, but the Linux system
> just takes forever to send the data.
>   
Serial Line Ip protocol? Can be a problem of your routing table?

Michael
> PGA
>
> On Sat, Jan 9, 2010 at 11:10 AM, Samuel Thibault
> <samuel.thibault@ens-lyon.org> wrote:
>   
>> Paul G. Allen, le Sat 09 Jan 2010 10:57:48 -0800, a écrit :
>>     
>>> In all cases, the profiler shows the serial Tx
>>> to be about 20x faster (twenty times) on Windows XP than in Linux.
>>>       
>> Did you properly set the serial port speed?
>>
>> Samuel
>>
>>     
>
>
>
>   

