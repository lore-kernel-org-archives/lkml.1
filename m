Return-Path: <linux-kernel-owner+w=401wt.eu-S2992992AbXEBJvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992992AbXEBJvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992986AbXEBJvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:51:44 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33987 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992992AbXEBJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:51:43 -0400
Message-ID: <46385EF8.8040005@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 11:50:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Valdis.Kletnieks@vt.edu, Andre Tomt <andre@tomt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so ... what *are* candidates for removal?
References: <Pine.LNX.4.64.0705011050080.11853@localhost.localdomain>            <46375D1C.4050404@tomt.net> <10590.1178037443@turing-police.cc.vt.edu> <4637C04E.4070306@s5r6.in-berlin.de> <Pine.LNX.4.64.0705020418530.7102@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0705020418530.7102@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Wed, 2 May 2007, Stefan Richter wrote:
> 
>> Regarding features that are overdue for removal according to
>> feature-removal-schedule.txt:
>>
>> I remember that at least one person used to watch for due dates for
>> feature removal, wrote the removing patches, and sent them to the
>> appropriate lists and maintainers.  This either got rid of the
>> obsolete stuff, or it turned up reasons why some feature could not
>> be removed just yet and how to update feature-removal-schedule.txt
>> to correctly reflect that.
>>
>> So, as they say, Patches Are Welcome.
> 
> that's a nice idea, but it doesn't address the problem that someone
> might go to the trouble to create such a patch and send it in, only to
> have that submission generate shrieking along the lines of "OHMIGOD,
> we can't delete that *yet*!!!"

You are absolutely right.

We have to try to avoid this waste of resources when we put features
into feature-removal-schedule.txt.  That's what I meant with "the hard
part" in the other post.

BTW, of course it doesn't suffice to say "we can't remove it yet" after
the due day.  There need to be well-founded reasons for another
deferral.  Of course if there are such reasons, it means something went
wrong when the feature was put into removal schedule.  (Some facts
weren't known.)

> that's the whole point of this wiki page:
> 
> http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed

Yep; if that page helps to collect the facts, then all the better.

Though in the very end, a feature goes away by means of a patch.

[...]
> i'm sure most people here can think of better things to do with their
> time.

Funny (or not so) how this sentence applies to all kinds of activities
into which more than one person is involved.  So let's try to plan our
work carefully and *timely*, to let as little of it go to waste as possible.
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/
