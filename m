Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZLLG7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZLLG7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZLLG7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:59:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42123
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbZLLG7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:59:52 -0500
Date: Fri, 11 Dec 2009 22:59:59 -0800 (PST)
Message-Id: <20091211.225959.102565811.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: gregkh@suse.de, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb_autopm_*() removal build failure...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091212175642.364e5734.sfr@canb.auug.org.au>
References: <20091212040524.GA11212@suse.de>
	<20091211.214714.41966763.davem@davemloft.net>
	<20091212175642.364e5734.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Sat, 12 Dec 2009 17:56:42 +1100

> Hi Dave,
> 
> On Fri, 11 Dec 2009 21:47:14 -0800 (PST) David Miller <davem@davemloft.net> wrote:
>>
>> This also means you weren't doing allmodconfig builds on your USB tree
>> this entire time, because if you had you would have realized that this
>> fix belonged there not in net-2.6 :-)  And if the USB bits were
>> going in via -next I'm really surprised Stephen Rothwell wasn't
>> complaining about this too :)
> 
> I did - a posting on Dec 9 with subject "linux-next: staging tree build
> failure" (which should have been "usb tree" - and I corrected that).

Awesome, my faith in the human race is restored :-)
