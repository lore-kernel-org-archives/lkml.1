Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYGJQjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYGJQjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 12:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYGJQjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 12:39:44 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:16304 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYGJQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 12:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZCVwwrzdM0MleOXqu8rO0aa8AKpKr6tssmzJpckuCJlqDkvPK2F/LPpq5/5kBr/1F0
         5d4vssqIFg7fLmlmWYxGmfs+48u9sUNv2A4B6oqMZvUp4gZib0GJVM1MY+eObVrfvdRX
         eNMqvuQYs8Dg5GPWS5dk88DzMlVl1bZGxcXhU=
Message-ID: <337eb86f0807100939mbd9be20xbbc7990afbabc9ab@mail.gmail.com>
Date: Fri, 11 Jul 2008 00:39:42 +0800
From: zhp <zhpsub@gmail.com>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: Is there any way to download all email archive of linux kernel, and then import to Gmail for search?
Cc: "Erik Mouw" <mouw@nl.linux.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080710173122.165849d4@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <337eb86f0807030721n1ab86217j2eb9a43d526ebf5f@mail.gmail.com>
	 <20080710062516.10342511.akpm@linux-foundation.org>
	 <20080710173122.165849d4@linux360.ro>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your help, guys!

I think it will be an viable method to achieve my goal in the following way:
1. Export part of or all (maybe Gmail cannot hold all) of the archive
mail from Gmane to a local mbox file.
2. Upload the mbox file to Gmail by Gmail Loader.

I will try this way and tell you the result.

I think it will be very nice if Google is willing to use its Gmail
technology to archive mail lists. Anyway, Gmail is the best Web Mail
(functionality, user experience) that I have ever used.

On Thu, Jul 10, 2008 at 10:31 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> On Thu, 10 Jul 2008 06:25:16 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Thu, 3 Jul 2008 22:21:42 +0800 zhp <zhpsub@gmail.com> wrote:
>>
>> > I have found that there is some methods for me to migrate local
>> > existing emails to Gmail for search.
>> >
>> > * Gmail Loader
>> > see http://www.linux.com/articles/60733
>> >
>> > * imapsync,
>> > see http://freshmeat.net/projects/imapsync/
>> >
>> > However, the problem is where can I get all of the old mails to my
>> > local computer?
>> > Has anyone done such things sucessfully?
>>
>> http://userweb.kernel.org/~akpm/lkml-mbox-archives/ might be useful.
>>
>> (Gad, 8MB/sec bandwidth from my Tokyo hotel room to kernel.org!)
>
> I'm reading LKML via NNTP from Gmane (not Gmail). But Gmane also
> provides mbox exporting, take a look at http://gmane.org/export.php
>
> I suppose you could use one of these two methods (NNTP or their export
> stuff) to download your old mails.
>
>
>        Cheers,
>        Eduard
>
