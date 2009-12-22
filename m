Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZLVOdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZLVOdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 09:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZLVOdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 09:33:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:13505 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZLVOdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 09:33:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DZPCWbW8lyCaxnB/jlJwXxbqnP7R+PadkC/zPJ8CBGG9+9lfHHmVZ/ARmoiAqpoz/O
         cBqgFB3tObxR73jChj9n4vYSrouax0MXtuS4zZtEeE5mT6v1ekdhCxZ+fMF95dJ2oiXJ
         Y9huKBNboCtyIFFr8DEdga5tuVfQLs/iRW8BI=
Message-ID: <4B30DC94.106@gmail.com>
Date: Tue, 22 Dec 2009 14:49:56 +0000
From: Dave Korn <dave.korn.cygwin@googlemail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Dave Korn <dave.korn.cygwin@googlemail.com>,
       Richard Henderson <rth@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <4B2FCCE3.1090209@redhat.com> <20091221201059.GD11669@n2100.arm.linux.org.uk> <4B30D2FE.9020209@gmail.com> <20091222141212.GA15356@n2100.arm.linux.org.uk>
In-Reply-To: <20091222141212.GA15356@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:

> [ ... ] this thread should probably die until some problem has actually
> been identified.
> 
> If it ain't broke, don't fix.

  <g>  Couldn't agree more.  Happy Christmas!

    cheers,
      DaveK
