Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZAFC1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZAFC1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAFC1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:27:22 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:58533 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZAFC1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l8hYz/IhQkelEMw66zst5/paS3KcUSrqqjEowCb+io8CBLkjReTqW/LVlRsX/VB7Xx
         +vh8sGq/qp6WE7SSJXSjmqjBc4BFvCvRIrCXHIorYXnQIKBz9r/5BhmYIGkBWn0OoIi+
         a0vPWQlwLw1U4eSAGvci6QQQfTOhIU//TuUG8=
Message-ID: <1f1b08da0901051827r57158990ic795208ba37120ad@mail.gmail.com>
Date: Mon, 5 Jan 2009 18:27:18 -0800
From: "john stultz-lkml" <johnstul.lkml@gmail.com>
To: linasvepstas@gmail.com
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: david@lang.hm, "Nick Andrew" <nick@nick-andrew.net>,
       "David Newall" <davidn@davidnewall.com>,
       "Kyle Moffett" <kyle@moffetthome.net>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net,
       mills@udel.edu, "Brian Haberman" <brian@innovationslab.net>,
       "Karen O'Donoghue" <karen.odonoghue@navy.mil>, ntpwg@lists.ntp.isc.org,
       zippel@linux-m68k.org
In-Reply-To: <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495F0672.6020708@davidnewall.com>
	 <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	 <4961432A.80509@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	 <20090105143335.GC18055@mail.local.tull.net>
	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 9:42 AM, Linas Vepstas <linasvepstas@gmail.com> wrote:
[snip]
> The long term solution would be write an RFC to extend
> NTP to also provide TAI information -- e.g. to add a
> message that indicates the current leap-second offset
> between UTC and TAI.

I believe Roman has already added this ability:
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=153b5d054ac2d98ea0d86504884326b6777f683d;hp=9f14f669d18477fe3df071e2fa4da36c00acee8e

thanks
-john
