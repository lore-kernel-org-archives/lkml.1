Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbXEARM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbXEARM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXEARM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:12:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:28497 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbXEARMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:12:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=pReL9Er0b11yaCwX1u2HYzoXLQcYO1NFtc+TWAGYRkjJ219lkRpEjtH5blMc5y9yAGWxsNUeN9exFt1Dh5r2xjFyaBpv/0XWxBklN9ibRVu5jkKzlvfW59QsJNwMx4nZbD4UW/XsXUtGrmcCfJi5MTk2Y4rKMi7g7CMe0zbwvx8=
Date: Tue, 1 May 2007 20:12:44 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <10210279863.20070501201244@gmail.com>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
CC: ian <spyro@f2s.com>, kernel-discuss@handhelds.org,
       <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [Kernel-discuss] Re: [RFC, PATCH 0/4] SoC base drivers
In-Reply-To: <46376D14.9060803@gmail.com>
References: <1354376306.20070501080806@gmail.com>  <46374645.2030900@gmail.com> <1178034935.15769.3.camel@wirenth> <46376D14.9060803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

Tuesday, May 1, 2007, 7:38:44 PM, you wrote:

> ian wrote:
>> On Tue, 2007-05-01 at 17:53 +0400, Dmitry Krivoschekov wrote:
>>> Hi Paul,
>>
>>> I think your referring to the term "SoC (system-on-chip)" is confusing
>>> (at least for me). You rather consider companion chips than SoCs.
>>
>> A 'System' does not imply a CPU. A 'Computer System' would but the word
>> system itself doesnt even imply electronic.
>>
>>
> A "system" means something complete. Yes I agree it doesn't imply a CPU,
> but acronym SoC traditionally imply something different than you propose.
> Adding another meaning for SoC will confuse people because they will have
> to distinguish if it is a processor or just a slave IC.

        I'm afraid we'd just have ontological argument unless tried to
bring in some references. But wikipedia does agree with you,
http://en.wikipedia.org/wiki/System-on-a-chip . So, well, down with
redefining SoC then. But "companion" is still too narrow and buzzwordy,
so let's explore Richard Purdie suggestion (in the other mail).


> Thanks,
> Dmitry


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

