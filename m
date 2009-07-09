Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbZGINQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbZGINQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760096AbZGINQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:16:44 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:62403 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759981AbZGINQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=SOHNr/WALgOYVUFSVCoi4BDFgstRvbA2FAi+R8fMkE9Qu7BNdD7m8zbAHYG/N9zn92
         pqHh+wkHbtlkgRT9L2it5x+ooWbDYJJIiMXMBSFyh8HEPKeFybyUySUxzUKcJ9R9XVTB
         SFieHk1/Yh5mga8H0ARMJCQNfWxLt+QPmshrQ=
MIME-Version: 1.0
Reply-To: john.lanza@linux.com
In-Reply-To: <4bbed3f70907082014t643209eaw5fc7cd7297f7af78@mail.gmail.com>
References: <4bbed3f70907082014t643209eaw5fc7cd7297f7af78@mail.gmail.com>
Date: Thu, 9 Jul 2009 09:16:41 -0400
Message-ID: <4bbed3f70907090616y2cb517a6s43214bc00d1a2f72@mail.gmail.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
From: John Lanza <jdlanza@gmail.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize to those of you who have already gotten this email.  I am
resending because I just learned the mailing list has been rejecting
my emails beacuse they are in HTML format.

johnl

On Wed, Jul 8, 2009 at 11:14 PM, John Lanza<jdlanza@gmail.com> wrote:
> All:
>
> I apologize for the lack of responsiveness on my part over the past couple
> of days.  Although I checked in dutifully over the weekend, most of Monday
> and Tuesday were consumed with a project.
>
> At this point, though, I have reached out to certain members of this
> community and provided at least an initial explanation.  I am willing to do
> the same for anyone interested -- simply reply back to this email and let me
> know of your interest.
>
> johnl
>
> On Tue, Jul 7, 2009 at 7:25 AM, Jamie Lokier <jamie@shareable.org> wrote:
>>
>> Boaz Harrosh wrote:
>> > I wish the lawyers people would come forward, as promised,,and explain
>> > what
>> > are the constraints on the short_name, given a long_name is present.
>> > I'm still waiting for that private mail in my e-box. If the names do not
>> > correspond at all but are both valid, why is that a problem?
>>
>> To be fair Tridge said there is a reason.
>>
>> The only problem is we don't know what it is...
>>
>> -- Jamie
>
>
