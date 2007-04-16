Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXDPFbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXDPFbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXDPFbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:31:41 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:54577 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbXDPFbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:31:41 -0400
Message-ID: <46230A3A.8060907@zachcarter.com>
Date: Sun, 15 Apr 2007 22:31:38 -0700
From: Zach Carter <linux@zachcarter.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Zach Carter <linux@zachcarter.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: BUG:  Bad page state errors during kernel make
References: <4622EDD3.9080103@zachcarter.com> <20070416035603.GD21217@redhat.com>
In-Reply-To: <20070416035603.GD21217@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Jones wrote:
> On Sun, Apr 15, 2007 at 08:30:27PM -0700, Zach Carter wrote:
>  > list_del corruption. prev->next should be c21a4628, but was e21a4628
> 
> 'c' became 'e' in that last address. A single bit flipped.
> Given you've had this for some time, this smells like a hardware problem.
> memtest86+ will probably show up something.

Hum.   I forgot to mention in my report that I had already run thru 10 clean passes with memtest86+

Do you think there might be other bad hw, or another explanation?

-Zach

