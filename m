Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXIOOfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXIOOfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXIOOfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:35:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48321 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbXIOOfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:35:19 -0400
Message-ID: <46EBEDA4.3070103@garzik.org>
Date: Sat, 15 Sep 2007 10:35:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Robin Humble <rjh@cita.utoronto.ca>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
References: <20070914185429.GA9439@2ka.mipt.ru> <46EADC02.9070409@garzik.org> <20070915135633.GA19482@lemming.cita.utoronto.ca>
In-Reply-To: <20070915135633.GA19482@lemming.cita.utoronto.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Humble wrote:
> On Fri, Sep 14, 2007 at 03:07:46PM -0400, Jeff Garzik wrote:
>> It is my hope that you will put your skills towards a distributed 
>> filesystem :)  Of the current solutions, GFS (currently in kernel) 
>> scales poorly, and NFS v4.1 is amazingly bloated and overly complex.
>>
>> I've been waiting for years for a smart person to come along and write a 
>> POSIX-only distributed filesystem.
> 
> it's called Lustre.
> works well, scales well, is widely used, is GPL.
> sadly it's not in mainline.

Lustre is tilted far too much towards high-priced storage, and needs 
improvement before it could be considered for mainline.

	Jeff



