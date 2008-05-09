Return-Path: <linux-kernel-owner+w=401wt.eu-S1765948AbYEIRHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765948AbYEIRHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYEIRH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:07:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:21747 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYEIRH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jLm5jh0mZfD+eyO9JvkOe5siTQg0XSyzmcBDJv7W19itwUXGCkUDVXq3ZeVdF5iLloguKCiQs5+8xR76SX/Jw/eGHLs4vArbJsyHUFW6bqW3HdgZXa02S940uoCdeppzN/fhmlIX+9WFBph5Y6Q4N0GV9KDrEDR01xxdT7kOxgM=
Message-ID: <dd18b0c30805091007j573b2cfoaeae0565f3b88913@mail.gmail.com>
Date: Fri, 9 May 2008 17:07:24 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: post-2.6.25 locks up hard without any message
Cc: "Jiri Slaby" <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080509184546.34de6cdb@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080425175423.4bfd1c7b@mjolnir.drzeus.cx>
	 <48125094.9070007@gmail.com>
	 <dd18b0c30804251650me69a06fi573418ed48a3261d@mail.gmail.com>
	 <20080428133523.34197aa3@mjolnir.drzeus.cx>
	 <dd18b0c30804280956l1c5553c9qf8f9763d375f9a1c@mail.gmail.com>
	 <20080509184546.34de6cdb@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2008 at 4:45 PM, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> Sorry about the lack of updates, but I haven't had time to do any more
> testing.
>
> Anyhoo, I did an update today and the machine is running fine so far.
> Looking at the git history, it seems the patch mentioned here was
> included, which would explain things.
>
> Thanks
> --
>     -- Pierre Ossman
>
>  Linux kernel, MMC maintainer        http://www.kernel.org
>  rdesktop, core developer          http://www.rdesktop.org
>

I'm glad to see everything is running smoothly, Over here I would have
to say everything is running smoothly as well,
except for a few things, which is fine to me, especially since this
kernel is under testing. I just need to learn to be more patient with
some of the issues, and try not to freak out. and take them as a
learning experience.
regards;

-- 
Justin P. Mattock
