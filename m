Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZH3Alv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZH3Alv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZH3Alu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:41:50 -0400
Received: from mail-yw0-f186.google.com ([209.85.211.186]:62372 "EHLO
	mail-yw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZH3Als (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:41:48 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Aug 2009 20:41:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RzudOuU4z92VRbxBgs8PDkT3T0cnmrvCDn76f2J1xugK2s9/oFwYwXhZBcUqT9iEyu
         MKc8yhe0LHuLS/D/yQ3Se+WR3K4+D6d+/TD+r1sqoaWCetEKMTzey+u2ja3gwdBn5ksW
         y55sxXI45zm510LBaU4w7WMuGhOClMJfNtgSk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0908281945590.10281@eeepc.linux-foundation.org>
References: <Pine.LNX.4.64.0908282358560.19623@boston.corp.fedex.com>
	 <1251476422.28787.1.camel@dhcp231-106.rdu.redhat.com>
	 <b6a2187b0908280930s6366eda6pe1d5024b4ef890dd@mail.gmail.com>
	 <alpine.LFD.2.00.0908281945590.10281@eeepc.linux-foundation.org>
Date: Sun, 30 Aug 2009 08:36:40 +0800
Message-ID: <b6a2187b0908291736j57d8ec83g2ffbe79ba610e16e@mail.gmail.com>
Subject: Re: Linux-2.6.31-rc8 inotify hangs samba clients
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 1:48 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
> On Sat, 29 Aug 2009, Jeff Chua wrote:
>>
>> Thanks again for the pointer and fixes. Will wait to pull from Linus's
>> git.
>
> Ok, I've merged the inotify things (along with a few others changes).
> Please do give it a good test. I'm going to be online only to a _very_
> limited degree (four-tank dive day tomorrow! Yeehaa), so I really hope
> that this solves it all.

Looks solved. Seems faster than before "introducing the bad fix".

Have a great dive!

Thanks,
Jeff
