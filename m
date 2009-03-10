Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZCJOTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZCJOTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZCJOTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:19:01 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:45842 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZCJOTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Vp1KUP28HNfdzcGFHv0PeL/OLb/OcSazY6tKPDr2CBg3uJ3KwV1DCbdu3kfcWAOcUK
         c2hyWum4H0Ji+h9UQsu87kFZF+PPPEHiUBWTcAWIdxX6iiKZKMEpz5rFVWazNQSmyysW
         NK2Eph+8FGn6vsP6ubp3Y4dUWx4mvzyfsyvnQ=
MIME-Version: 1.0
In-Reply-To: <20090310124658.GE8840@mit.edu>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
	 <20090310124658.GE8840@mit.edu>
Date: Tue, 10 Mar 2009 17:18:55 +0300
Message-ID: <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com>
Subject: Re: next-20090310: ext4 hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/10 Theodore Tso <tytso@mit.edu>:
> On Tue, Mar 10, 2009 at 03:17:51PM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> It is similar to http://lkml.org/lkml/2009/2/6/304,
>> http://bugzilla.kernel.org/show_bug.cgi?id=12579
>>
>> I run dbench on ext4 on loop on ext3 on sparc.
>> The kernel is 2.6.29-rc7-next-20090310
>> e2fsprogs -1.41.4
>
> Thanks for reporting this; does it show up on stock 2.6.29-rc7?
No, I can not reproduce it.
It is a slow system, I would not like to bisect it, only if it is the
last possibility.
