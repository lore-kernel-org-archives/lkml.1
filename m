Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbXGBHMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbXGBHMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 03:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXGBHMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 03:12:36 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:21496 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXGBHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 03:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rmqva4fTD2rM1c+y1yogJPzYui7VWuqI9I9v/MqR+Y/h/RV+JgHLA90IpLhwPa0hGDZFYLnKdklZ6HDSAZchqKqT33YU2jeNdyoWqLAWfeVMIpnye77N+8t210EqvJEtttEo2TXoYkLdDjP+rlw62qihAzr4h8Rlr4CUuq2D2b0=
Message-ID: <4688A55B.3020504@gmail.com>
Date: Mon, 02 Jul 2007 16:12:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, enricoss@tiscali.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc5] libata: add HTS541616J9SA00 to NCQ blacklist
References: <fa.sspu6LOivd/touNtS2IsMKPqHa0@ifi.uio.no> <fa.19XJG1Asdp1zwcWLxolIH6F+5lY@ifi.uio.no> <467EC909.9040006@shaw.ca> <467F2495.3080509@gmail.com> <467F286B.40607@gmail.com>
In-Reply-To: <467F286B.40607@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Another member of HTS5416* family doing spurious NCQ completion.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Enrico Sardi <enricoss@tiscali.it>

Jeff, ping.

-- 
tejun
