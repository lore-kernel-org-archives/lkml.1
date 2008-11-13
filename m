Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYKMU43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYKMU43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYKMU4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:56:19 -0500
Received: from mail-gx0-f19.google.com ([209.85.217.19]:53308 "EHLO
	mail-gx0-f19.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYKMU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:56:18 -0500
X-Greylist: delayed 949 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2008 15:55:58 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=liM9Sfdn/EPolTebugLaSeZ0WjoVmW1wL1VlGttJ6EJ51aG+iRrFTbHln9tpGLNjn6
         y/hakC9KvnhxOc97fVdRjU1T30zlMbSeAKjT5jDM0N/ltH/mXmTRXtiZhoJQN4OWiJdp
         eXqsugQ4Xvr0B4WELrojmfmXneX1hQeVCuohk=
Message-ID: <43e72e890811131254q35ff4f48xf58c7c26d5c9a5a4@mail.gmail.com>
Date: Thu, 13 Nov 2008 12:54:07 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [madwifi-project] [RFC] Closing the project
Cc: "Michael Renzmann" <mrenzmann@madwifi-project.org>,
       madwifi-project@venema.h4ckr.net,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1226609316.2904.18.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2576.194.45.26.221.1226491274.squirrel@webmail.madwifi.org>
	 <1226511194.9952.38.camel@dv>
	 <43e72e890811121224w4fc53e1s29080a42111186e9@mail.gmail.com>
	 <1226547092.11785.49.camel@dv>
	 <43e72e890811131142p3f72c964t802d424b0ddb3456@mail.gmail.com>
	 <1226609316.2904.18.camel@dv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 12:48 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2008-11-13 at 11:42 -0800, Luis R. Rodriguez wrote:
>

>> > I think the biggest impediment to MadWifi development was not
>> > bureaucracy.  It was the non-free HAL.
>>
>> Not really, even with an alternative people are still used to coding
>> with it and find it easier to commit into an svn repository than
>> submit  patches upstream. Maybe our process is move involved but there
>> its also why Linux code has a certain quality in it. We tend to frown
>> upon crap. If MadWifi ever were to touch Linux it would be tainted
>> with CRAP.
>
> OK, HAL was not the only reason.  Let's say there is good bureaucracy
> and bad bureaucracy.  The difference is the former is helpful and the
> later is not.  The kernel is an excellent example of good bureaucracy
> that we should learn from.
>
> It would be great to have a detailed analysis why MadWifi failed.

It didn't fail, it was just not the best approach to support Linux
from the start, that's why *today* its just silly to go on with it,
specially since the vendor involved is *contributing* and helping to
implement support the right way.

>> Just my advice: let MadWifi die already, stop wasting your time.
>
> I understand what you mean, but I have to deal with MadWifi anyway.  As
> I said before, I'd rather share my fixes that keep them to myself.

Understood -- but perhaps you can identify what is lacking that you
need to better help push what is required and missing.

 Luis
