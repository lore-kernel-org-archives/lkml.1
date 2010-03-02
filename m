Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0CBKOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:14:04 -0500
Received: from lo.gmane.org ([80.91.229.12]:45437 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0CBKOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:14:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: Oops while booting 2.6.34-rc0 (block pull busted)
Date: Tue, 02 Mar 2010 02:13:47 -0800
Message-ID: <hmiocs$p6h$1@dough.gmane.org>
References: <201003011615.31709.dmitry.torokhov@gmail.com> <20100302075656.GO5768@kernel.dk> <20100302081547.GP5768@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-177-68.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.3a3pre) Gecko/20100301 Shredder/3.2a1pre
In-Reply-To: <20100302081547.GP5768@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 12:15 AM, Jens Axboe wrote:
>> On Mon, Mar 01 2010, Dmitry Torokhov wrote:

>>> It looks like block tree that has been pulled today into mainline is
>>> busted, I am getting the Opps below on boot with the following commit:
>>>
>>> commit b1bf9368407ae7e89d8a005bb40beb70a41df539


>....Can you also try and see if reverting
> 9f7cdbc33f36d28e57eaba0093f68f0d14c38c5b makes it work?

I'm getting the same oops and reverting that commit fixes it, thanks.
I'm happy to test patches, etc.


