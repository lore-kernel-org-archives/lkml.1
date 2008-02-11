Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYBKNv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYBKNv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBKNvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:51:49 -0500
Received: from trashmail.net ([213.155.82.90]:45585 "EHLO trashmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbYBKNvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:51:48 -0500
Message-ID: <47B0536D.3070000@trashmail.net>
Date: Mon, 11 Feb 2008 14:53:49 +0100
From: "rzryyvzy" <rzryyvzy@trashmail.net>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Help debugging filesystem activity?
References: <20080211131713.DC7435193B631@trashmail.net> <3d8471ca0802110528g16cad94y4351795527f3917@mail.gmail.com>
In-Reply-To: <3d8471ca0802110528g16cad94y4351795527f3917@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain schrieb:
> On Feb 11, 2008 2:17 PM, rzryyvzy <rzryyvzy@trashmail.net> wrote:
>   
>> $ cat /proc/fs/vfs/reading_files
>>
>> $ cat /proc/fs/vfs/writing_files
>>     
>
> You can try:
>
> # echo 1 > /proc/sys/vm/block_dump
> # dmesg
>   
Thanks, it works. This option rocks. I did not know about that.
This is what I really like in Linux: Everything is possible.

-- 
Best regards,
Mika Lawando

