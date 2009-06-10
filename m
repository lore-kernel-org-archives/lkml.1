Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbZFJVIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbZFJVIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbZFJVIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:08:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61128 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbZFJVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:08:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=w88S8aTfJl7WGz1Y/FDCJTFgQPGOLGur/v9+8zo6D4CH5F2RmMqgsxaz0zlkmfHva
	6/U7+oB3UjvIiBnVwW5KQ==
MIME-Version: 1.0
In-Reply-To: <20090610204708.GD6251@dodger.lab.datenfreihafen.org>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
	 <20090610204708.GD6251@dodger.lab.datenfreihafen.org>
Date: Wed, 10 Jun 2009 14:08:36 -0700
Message-ID: <a55d774e0906101408t75e507f5s8064796b080828c2@mail.gmail.com>
Subject: Re: MSM6281 support was: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 1:47 PM, Stefan
Schmidt<stefan@datenfreihafen.org> wrote:
> Hello.
>
> On Wed, 2009-06-10 at 13:24, Brian Swetland wrote:
>>
>> We have full support for MSM7201A, including fully functional power
>> management, working on a number of commercially shipping devices that
>> we'd absolutely love to get into mainline.
>
> A bit offtopic here. (subject change). Is it expected that the android kernel
> team will also work on systems that use the MSM6K modems with different SoC's? I
> have soem systems here that use an msm6281 on a dual port ram chip with non msm
> SoC's. I wonder how difficult it would be to adaept the existing msm smd driver
> to such a setup.

We only have documentation, support, and permission to do work on 7k
and 8k family devices at this point.  I don't know anything about the
6k family, and how similar (or not) the shared memory interface would
be, so unfortunately I can't provide much help there.

Brian
