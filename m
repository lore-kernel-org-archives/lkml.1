Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbZCQJk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbZCQJk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZCQJkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:40:06 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40048 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbZCQJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:40:04 -0400
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
Message-Id: <3DA733C2-2755-4D42-9512-7E7110B39526@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20090316114441.GF2405@elf.ucw.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: 2.6.29-rc5+: usb bluetooth crashes system
Date: Tue, 17 Mar 2009 10:39:54 +0100
References: <20090310112307.GD1337@ucw.cz> <20090314034852.GA3417@kroah.com> <20090316114441.GF2405@elf.ucw.cz>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> Since switch to 2.6.29-rc, bluetooth crashes system... usually on
>>> disconnect or killall pppd.
>>
>> Do we have a trace?
>
> We have "bad magic" message, see bugzilla. I guess it is use of
> spinlock after free?

can you double check with the net-next-2.6 or bluetooth-next-2.6 tree  
and see if that issue is still present.

Regards

Marcel

