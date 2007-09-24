Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbXIXDWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbXIXDWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 23:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXIXDWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 23:22:43 -0400
Received: from dvhart.com ([64.146.134.43]:48010 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbXIXDWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 23:22:43 -0400
Message-ID: <46F72D80.20504@mbligh.org>
Date: Sun, 23 Sep 2007 20:22:40 -0700
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Natalie Protasevich <protasnb@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Diego Calleja <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, David Ames <david@linux-foundation.org>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>
Subject: Re: Urgent bugzilla mainteinance needed
References: <20070923195821.cab02f42.diegocg@gmail.com>	 <32209efe0709231108v459c3559xf247db2c122513c0@mail.gmail.com>	 <1190572240.22181.2.camel@shinybook.infradead.org> <32209efe0709231134t1dda4965i6e1d49a8d134c664@mail.gmail.com>
In-Reply-To: <32209efe0709231134t1dda4965i6e1d49a8d134c664@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Natalie Protasevich wrote:
> On 9/23/07, David Woodhouse <dwmw2@infradead.org> wrote:
>> On Sun, 2007-09-23 at 11:08 -0700, Natalie Protasevich wrote:
>>> On 9/23/07, Diego Calleja <diegocg@gmail.com> wrote:
>>>> Take a look at http://bugzilla.kernel.org/show_bug.cgi?id=3710
>>>>
>>>> bugzilla tries to send a mail to the reporter, it fails ("unknown user account"),
>>>> but the error failure is appended as a bugzilla comment. Then bugzilla tries to
>>>> send that comment to everyone involved in the bug, including the reporter,
>>>> so it fails again.....Houston, we've a endless loop.
>>>>
>>>> There're 540 comments in that bug report already, and the bugme-daemon
>>>> mail list is being spammed....
>>> I just sent emails to those who maintain bugzilla software and systems
>>> that run it, hope someone will be online soon to help alleviate
>>> this...
>> Bugzilla really shouldn't be accepting any mail with empty reverse-path
>> (MAIL FROM:<>)
> 
> Ah, then should be easy fix then. I don't have access to the system
> though, will have to helplessly wait until one of the guys picks up...
> :(

Sorry, can't fix this - I don't have direct access to the system,
and I don't think the others will be back until Monday ;-(

M.
