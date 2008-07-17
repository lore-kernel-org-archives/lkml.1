Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYGQMbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYGQMbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYGQMbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:31:10 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39078 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752818AbYGQMbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:31:09 -0400
Message-ID: <487F3B6D.3090507@suse.de>
Date: Thu, 17 Jul 2008 16:30:37 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: alan-jenkins@tuffmail.co.uk, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other	GPEs)
 on Asus EeePC
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net>
In-Reply-To: <20080717121309.GF31732@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Thu, 17 Jul 2008, Alexey Starikovskiy wrote:
>> Thanks for the patch, ACK.
> 
> This one fixes a potentially bad problem, since we could ignore more than
> just hot key EC events by accident.  Maybe it should go to -stable?

I vote for it

Regards,
Alex.
