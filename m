Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbZDGWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbZDGWAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbZDGWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:00:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:64548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223AbZDGWAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LOCPro8TQ9CzdIJHdYNddvxz5ddZr3FNlTQ+K7Jf2a9NT5hHXb6PgVyrQzd3mwM3RW
         Dv2It0uxWWeLRVlJ0kq95RYNOrwTEwAYqfGnmJZS3wwo8gugCDJUW55WaHdM9JoRHi/U
         AUl80hvcvnHj0cRmWCAJhpN6V38yaTo1dufVw=
MIME-Version: 1.0
In-Reply-To: <200904072330.59738.rjw@sisk.pl>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <9b1675090904061913o614e02fdl22ef2cf795525a6d@mail.gmail.com>
	 <9b1675090904061914m4d5e204lbf726a07ba406cf2@mail.gmail.com>
	 <200904072330.59738.rjw@sisk.pl>
Date: Tue, 7 Apr 2009 16:00:18 -0600
Message-ID: <9b1675090904071500i1e57c4d7s4c5e658530c57af0@mail.gmail.com>
Subject: Re: [Bug #13018] 2.6.29 on MacBook 2,1 fails to reboot
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       mstevens@win-professional.com, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, someone named Stefan has been discussing it with me as well.
See the other macbook thread.

On Tue, Apr 7, 2009 at 3:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 07 April 2009, Trenton D. Adams wrote:
>> On Mon, Apr 6, 2009 at 8:13 PM, Trenton D. Adams
>> <trenton.d.adams@gmail.com> wrote:
>> > Hi Rafael,
>> >
>> > Yes, it is still a problem.  I have identified it as far down to being
>> > an alsa problem.  Please follow the other thread related to this.  I
>>
>> Oops, sorry, I should make clear that it is not an alsa problem
>> specifically, but an alsa hda-intel driver issue, which is related to
>> alsa.
>
> OK, thanks for the update.
>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
