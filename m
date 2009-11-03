Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZKCVHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZKCVHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZKCVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:07:13 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:65403 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbZKCVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:07:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=FzfcHeUC81dBnKKmT//seUYQDsZ48Mzb7c+geCpWQ6xzDByADhJhWhuoBCj4/Wcmat
         GMbspmiE14M/Nw/nN2x9Zmnu6C89hASjPKqxSl+j5aTfTkfPgFVX6yzIW6yqOOqDz6VF
         0CDPaVXDJ7HUnQ07Mae5ihyRV+ngv6szmWVkw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Tue, 3 Nov 2009 22:04:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1256886023.3555.5.camel@johannes.local> <200911032059.23409.bzolnier@gmail.com> <200911032132.31533.IvDoorn@gmail.com>
In-Reply-To: <200911032132.31533.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200911032204.51085.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009 21:32:30 Ivo van Doorn wrote:

> > rt2800pci patch itself has been getting dust in your tree since at least
> > April (it hasn't received any bigger updates since then)..
> 
> And how many times do I have to repeat the reason?
> I think that after dozens of mails, the message should have been clear, especially
> to somebody who apparently has been monitoring and worrying about the development
> process for the last 2 years....

Just for the record:

I got only interested in rt2x00 support around April this year (while I was
doing major staging cleanups everywhere) and I was hearing back then that
rt2800pci will be merged "really soon" and that the project is making "great
progress"..

-- 
Bartlomiej Zolnierkiewicz
