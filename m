Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXIXQHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXIXQHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXIXQHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:07:04 -0400
Received: from dvhart.com ([64.146.134.43]:58346 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbXIXQHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:07:03 -0400
Message-ID: <46F7E0A0.8070905@mbligh.org>
Date: Mon, 24 Sep 2007 09:06:56 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Natalie Protasevich <protasnb@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       David Ames <david@linux-foundation.org>
Subject: Re: Urgent bugzilla mainteinance needed
References: <20070923195821.cab02f42.diegocg@gmail.com>	 <32209efe0709231108v459c3559xf247db2c122513c0@mail.gmail.com>	 <1190572240.22181.2.camel@shinybook.infradead.org> <32209efe0709231134t1dda4965i6e1d49a8d134c664@mail.gmail.com> <46F72D80.20504@mbligh.org> <46F7DEF2.1020104@linux.vnet.ibm.com>
In-Reply-To: <46F7DEF2.1020104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> Bugzilla really shouldn't be accepting any mail with empty reverse-path
>>>> (MAIL FROM:<>)
> Updated to handle this case.
>>> Ah, then should be easy fix then. I don't have access to the system
>>> though, will have to helplessly wait until one of the guys picks up...
>>> :(
>> Sorry, can't fix this - I don't have direct access to the system,
>> and I don't think the others will be back until Monday ;-(
>>
>> M.
> It should be working now.  Thanks to David Ames for handling the mailer
> part.  I cleaned the spam(1353 msgs) out of the bug.

Awesome - thanks to both of you.

M.
