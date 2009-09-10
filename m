Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZIJAVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZIJAVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZIJAVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:21:52 -0400
Received: from mail-iw0-f200.google.com ([209.85.223.200]:36818 "EHLO
	mail-iw0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZIJAVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=obTHIsKeUYkc4VC8PatFb4BsnlgCV4PEiXfHXhhCMHk2O2MndWD/BCr5bCKCbvv6LW
         2abvgsp3/EvFOIecwBBtDIdfL/G+ZQcTywEUWId9evCtywQ62KjB3AughUWPQhk7Fok/
         feEb5aQVsgdUE4ZERIz9NFaJ2RzOXJTTjk0x0=
MIME-Version: 1.0
In-Reply-To: <20090909224455.GB2077@kroah.com>
References: <20090905001824.GA18171@kroah.com> <43e72e890909081223w3e50eee6v438411462a7ed534@mail.gmail.com> 
	<20090909224455.GB2077@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 9 Sep 2009 17:21:34 -0700
Message-ID: <43e72e890909091721r3016db52i7328bac5d978c26c@mail.gmail.com>
Subject: Re: [Stable-review] [patch 00/71] 2.6.30.6-stable review
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 3:44 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Sep 08, 2009 at 12:23:29PM -0700, Luis R. Rodriguez wrote:
>> On Fri, Sep 4, 2009 at 5:18 PM, Greg KH<gregkh@suse.de> wrote:
>> > This is the start of the stable review cycle for the 2.6.30.6 release.
>> > There are 71 patches in this series, all will be posted as a response to
>> > this one.  If anyone has any issues with these being applied, please let
>> > us know.  If anyone is a maintainer of the proper subsystem, and wants
>> > to add a Signed-off-by: line to the patch, please respond with it.
>> >
>> > These patches are sent out with a number of different people on the Cc:
>> > line.  If you wish to be a reviewer, please email stable@kernel.org to
>> > add your name to the list.
>>
>> I think this automated message needs some updated to reflect the fact
>> that a mailman list is used now, and redirect people to help
>> themselves to help us by subscribing to:
>>
>> http://linux.kernel.org/mailman/listinfo/stable-review
>>
>> > If you want to be off the reviewer list,
>> > also email us.
>>
>> This seems to not be required any more.
>
> True.  Care to send a patch against the stable-queue where this message
> is:
>        http://git.kernel.org/?p=linux/kernel/git/chrisw/stable-queue.git;a=summary

Sure, that hasn't been updated since 2006, is that the right tree?

  Luis
