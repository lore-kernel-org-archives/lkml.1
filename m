Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYJ1QM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYJ1QM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYJ1QMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:12:14 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:40547 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYJ1QMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gimNBLJ3SCBVYEfDWgTifNyaBKQGq7mm+sFblpHU9COBKTr6D51t3hW5pp4b0egN7Y
         xU1FwjSaArde9cBZ1TpNpkivDJABQk4vulf+TdgBlArPHSbdMqZVMI0mMBVCwSDPBpmv
         poqOa/Ovug2T90F0tNnsrNsgiHqdlM2njd+ls=
Message-ID: <1ba2fa240810280912pea7284ejd6de5d04efbb974f@mail.gmail.com>
Date: Tue, 28 Oct 2008 18:12:09 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Soeren Sonnenburg" <kernel@nn7.de>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200810281630.28389.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810272350.29429.rjw@sisk.pl>
	 <1ba2fa240810271612g72bb2b08p6ebab9f6f02f5b98@mail.gmail.com>
	 <200810281630.28389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 5:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 28 of October 2008, Tomas Winkler wrote:
>> h
>>
>> On Tue, Oct 28, 2008 at 12:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Monday, 27 of October 2008, Tomas Winkler wrote:
>> >> On Tue, Oct 28, 2008 at 12:28 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
>> >> > On Mon 27.Oct'08 at 23:07:00 +0200, Tomas Winkler wrote:
>> >> >>[...]
>> >> >>
>> >> >> Can someone try this one (it might be space broken I've just pasted
>> >> >> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
>> >> >> (latest linux-2.6.git)
>> >> >
>> >> >
>> >> > Yes, this one also works for me (I applied it manually).
>> >> Good, this was actually part of some older and bigger patch I wasn't
>> >> aware it has this affect. It has some millage in iwl5000 branch.
>> >> RFKIll went through some changes in the mainline so it wasn't merged yet.
>> >
>> > Are you going to push this patch upstream now?  It's quite important to get
>> > this resume regression fixed ASAP.
>>
>> Definitely I would post it to wireless and stable.
>
> Please send a CC to me too.
Hmm. It looks like I've misspelled your email when I've sent the patch.
Will send it again
Tomas
