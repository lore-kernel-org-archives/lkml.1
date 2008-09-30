Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYI3Wmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYI3Wmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYI3Wmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:42:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:36750 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYI3Wmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=puI8DAKLS6ZmWRv+sKDZxF9sdDYQZoa4Isn/FYHNgSqf48OZQSjB9R7byEZkeIeL7q
         x+F0UUb5753JLsBR+YuckUkbX4YPoOJ1WF+MlVofDLZ/BmbbU5UqkzmlFD3y3QCjGK35
         hmYvu0tXJA+D+kjtZzDuB6Eqid4e5JfZOaXzg=
Message-ID: <f7848160809301542s31908f92x4db94b0f9478502f@mail.gmail.com>
Date: Tue, 30 Sep 2008 18:42:43 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ksoftirqd/1] CPU reporting.
Cc: lkml <linux-kernel@vger.kernel.org>, "Jon Smirl" <jonsmirl@gmail.com>
In-Reply-To: <f7848160809301539i1ebc7c2ek185c1589839a3d78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910809300741n1da80e6ep777c39bc1373417c@mail.gmail.com>
	 <f7848160809301539i1ebc7c2ek185c1589839a3d78@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 6:39 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> On Tue, Sep 30, 2008 at 10:41 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
>> What's up with ksoftirqd? I'm pretty sure it hasn't used 14,676 years
>> of CPU time.
>> Linus current git on a Q6600 64b.
>>
>> jonsmirl@terra:~/fs$ ps aux
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root         7 160920245  0.0 0     0 ?        S<   07:27 21133795:38
>> [ksoftirqd/1]
>
> Uh oh - Here we go again.
>
> Rafael - time for re-reopening of
> http://bugzilla.kernel.org/show_bug.cgi?id=11209 I suppose?
>

Forgot to include Rafael on the previous one.

Parag
