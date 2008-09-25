Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYIYO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYIYO5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbYIYO5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:57:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:44320 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbYIYO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X3eTDAd2NGFdYLKVbG1GieA3zgF+9cu80PfCmmfcOwrW++UlNrfjhFhZnVLbV91RJA
         5F2Gg7PM/HD6kclW8prXpGEaBkA+19jg8AvsXbvqfg+hVOCuge/1ot7MrjuZ3OrRHIxc
         Ybha08OeGsAYchqMNDJl11RrUTRfOdtVdzhE4=
Message-ID: <1ba2fa240809250757x32aa450k523d71e555c221e4@mail.gmail.com>
Date: Thu, 25 Sep 2008 17:57:33 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2008-09-24
Cc: "Zhu Yi" <yi.zhu@intel.com>, "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080925114133.GA5044@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924231720.GD3639@tuxdriver.com>
	 <1222321622.2510.455.camel@debian.sh.intel.com>
	 <20080925114133.GA5044@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 2:41 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Sep 25, 2008 at 01:47:02PM +0800, Zhu Yi wrote:
>> On Wed, 2008-09-24 at 17:17 -0600, John W. Linville wrote:
>> > Dave,
>> >
>> > One more for 2.6.27 -- a fix for a possible interrupt storm.  There is
>> > even a link in the commit log to a youtube video of the storm in
>> > progress. :-)
>> >
>> > Let me know if there are problems!
>>
>> Can you also add this one? It doesn't panic the kernel when a frame from
>> firmware is invalid.
>>
>> http://marc.info/?l=linux-wireless&m=122219037706528&w=2
>
> Is there an open bug report for that anywhere?  Is this something
> that real users (no offense to Johannes) are likely to hit?

I'm just exporting the major bugs from our internal database to
buzilla, 5000 is new so
we are hitting the problems during testing  before users report them.

Now I don't know if it was good idea to push the driver upstream same
time as it hits the market.
Tomas
