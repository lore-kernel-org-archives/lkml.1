Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbYECPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbYECPoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbYECPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:44:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58391 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbYECPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:44:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481C881D.4010708@s5r6.in-berlin.de>
Date: Sat, 03 May 2008 17:43:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: SL Baur <steve@xemacs.org>, linux-kernel@vger.kernel.org
Subject: Re: How to reduce the number of open kernel bugs
References: <20080502124210.GB5838@cs181133002.pp.htv.fi> <ed10ee420805030313r457d8cdfjdbcb346ae928c125@mail.gmail.com> <20080503112118.GK5838@cs181133002.pp.htv.fi>
In-Reply-To: <20080503112118.GK5838@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, May 03, 2008 at 03:13:21AM -0700, SL Baur wrote:
>> On 5/2/08, Adrian Bunk <bunk@kernel.org> wrote:
>>> Just seen in the kernel Bugzilla (driver anonymized to foobar):
>>  ... An all too common sequence
>>
>> This is the kind of stuff that naturally happens when you tie performance
>> to the progression of bug reports through bug tracking systems.  It's
>> human nature.
> 
> That's a problem elsewhere, but not the problem here.
> 
> As far as I know this maintainer developed and maintaines this driver as 
> a hobby.
> 
>> It's not good, but it's human nature.  This situation is *not* unique to Linux.
>>
>> -sb (My day job is the care and feeding of a Fortune 50 company's internal bug
>> tracking system)

Adrian, what is it that you criticize?  Was it an impolite tone in the 
maintainer's responses, or do you believe that the maintainer lied to 
the reporter?

Or did the maintainer miss to do something which he would be able to and 
had the resources to do?

Or did the maintainer refuse to fulfill an obligation?

If it is one of the latter points, is it that the maintainer failed, 
according to your observation, to explain in more detail why he closed 
the bug early, in a way that a person without deep technical insight 
into the problem domain can parse?  Or to ask for information which 
would bring the bug forward?  Or to analyze the problem deeper on his 
own?  Or use the bugzilla system in a more sophisticated way (reassign, 
set status, change title... instead of closing the bug and requiring the 
reporter to create a different bug entry)?

Not as an excuse for anything, but to bring in another perspective, let 
me remind that especially maintainers who work in spare time often 
handle bugs at daytimes when the ability to analyze technical or 
procedural problems is reduced.  That's because there is little choice 
when to work on what.  (People who work professionally in this area 
hopefully do so under proper working conditions.)

Or a maintainer may not be fluent in the most efficient use of the bug 
tracker, or bug handling in general.  If so, then there need to be 
persons who assist in the bug handling.  Ideally the maintainer will 
gather experience in effective bug handling over time.  (Again, people 
who do this professionally hopefully received the necessary training. 
Also, an employer who is interested in good relationships with customers 
takes care that his contact staff is socially skilled and motivated.)

If you want maintainers to change their behavior, what are you going to 
do?  Raise awareness (like you apparently intended to by starting this 
thread and a number of other of your postings)?  Do you want to motivate 
maintainers in a negative way (make them feel guilty) or in some 
positive way?  Do you want to or have ideas how to improve process 
skills of the maintainers?  Are you going to find ways to lower 
maintainers' workload?

If you feel that obligations haven't been fulfilled in the case which 
you presented:  What is founding those obligations?

Lastly, what do you think does the number of open kernel bugs (or rather 
the inverse of it) mean to people?  Is it something like having an 
expensive looking car parked in front of the house?  I would say 
bugzilla.kernel.org is too obscure and cryptic to be able to fulfill 
that kind of role.
-- 
Stefan Richter
-=====-==--- -=-= ---==
http://arcgraph.de/sr/
