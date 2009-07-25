Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbZGYOCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbZGYOCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZGYOCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:02:51 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:64333 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbZGYOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:02:51 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Regression] kdesu broken
Date: Sat, 25 Jul 2009 16:02:48 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, ray-lk@madrabbit.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
References: <200907240145.31935.rjw@sisk.pl> <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com> <200907241721.45943.rjw@sisk.pl> <20090724164058.21a054e6@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907240930120.3960@localhost.localdomain> <alpine.LFD.2.01.0907240930120.3960@localhost.localdomain> <20090725124859.530d158b@lxorguk.ukuu.org.uk>
In-reply-To: <20090725124859.530d158b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251602.49918.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 14:02:50.0552 (UTC) FILETIME=[98BBDB80:01CA0D30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Linus Torvalds wrote:
>> We don't do regressions. If user space depended on old behavior, we
>> don't change behavior
> 
> I think there are two bugs being confused here. The first kdesu bug
> isn't the EIO one. It's just busted userspace code that happened to be
> lucky. 
> It's also impossible to keep that "luck" going. The other problem is the
> EIO - which is a bug.
 
Just out of curiosity ad for reference.
Has this issue already been reported to the KDE people? Any links to a bug 
report or discussions there?
