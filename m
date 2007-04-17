Return-Path: <linux-kernel-owner+w=401wt.eu-S1031066AbXDQDTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031066AbXDQDTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 23:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031069AbXDQDTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 23:19:36 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:38944 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031066AbXDQDTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 23:19:35 -0400
Message-ID: <46243CC5.3090501@zachcarter.com>
Date: Mon, 16 Apr 2007 20:19:33 -0700
From: Zach Carter <linux@zachcarter.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG:  Bad page state errors during kernel make (resolved)
References: <4622EDD3.9080103@zachcarter.com> <20070416035603.GD21217@redhat.com> <46230A3A.8060907@zachcarter.com> <46240888.1040804@redhat.com>
In-Reply-To: <46240888.1040804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> Zach Carter wrote:
>>
>> Do you think there might be other bad hw, or another explanation?
> 

Well, after updating the BIOS for the motherboard, I was able to rebuild the kernel 6 times in a row 
with no page state errors.  I noticed that the recent BIOS update includes "Enhanced compatibility 
with Linux":

	http://www.abit-usa.com/products/mb/bios.php?categories=1&model=316

In case anyone searching the ML archive has the same problem, the motherboard is an ABIT KN9 ULTRA 
Socket AM2 NVIDIA nForce 570 Ultra MCP ATX

-Zach
