Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbXLaEvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbXLaEvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 23:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXLaEvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 23:51:03 -0500
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:47520 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752437AbXLaEvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 23:51:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PSVG7qesph0mjFTsL7GYZczcET/LZAcZMnl76AuRRfQbzo+WnAEkKrdHlgo1wwjboxuch0gGWZ5h/SR0og5b0jg2Q4LC+GOqtWI+Pi76PGB8jU2gAAQFAfMfdFiHcWeIf7v8s1HbkVbNikaR3rdUbcaZaCQaz6DDnhLUr/t0ucw=;
X-YMail-OSG: WSYvQvEVM1m.knKH8cv2weN.SybcywGmECTr9tbVRHvbENyyEKflZPptiXYX6SzQao0MRhKGrWuQOhwH8B6VUO5ArENGK76UuwA8E6Kinwbj.38-
Date: Sun, 30 Dec 2007 20:51:00 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, drzeus@drzeus.cx
In-Reply-To: <200712310115.25455.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <259674.66754.qm@web36702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:

> 
> So do we require changes to the userspace udev rules here, or just some use of 
> modalias in the drivers?
> 

It was handled by whoever manages the distro's udev rules until now. Here's the example:

https://lists.ubuntu.com/archives/ubuntu-patches/2007-September/012537.html




      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
