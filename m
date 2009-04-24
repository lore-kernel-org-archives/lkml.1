Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbZDXWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbZDXWJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbZDXWJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:09:10 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:42755 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZDXWJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=iTBkwP/TLboTsxjoBEpdMtcHtn0bXSDaqxR2ZEuqkfKj5NL8PZepAbgjBqLs4zPqpV
         2LP56NtOIl8XZDcPYvUMtS1viWAjxYNzJ0X9/m1tllSjnhmIlu6mzjhKlfsjuwj7TIdM
         ms9rhAndEIwmkEkoX5IrfMGkyxe1g7bopbs8o=
MIME-Version: 1.0
In-Reply-To: <49F22D49.6000806@garzik.org>
References: <49F210C2.8050703@gmx.net> <49F22D49.6000806@garzik.org>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 24 Apr 2009 15:08:52 -0700
X-Google-Sender-Auth: 43aab17807e9abb2
Message-ID: <2c0942db0904241508y7b8cf90bw71b9e25e71e3f34@mail.gmail.com>
Subject: Re: Link to sata drives fail randomly
To: Jeff Garzik <jeff@garzik.org>
Cc: LCID Fire <lcid-fire@gmx.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 2:21 PM, Jeff Garzik <jeff@garzik.org> wrote:
> LCID Fire wrote:
>>
>> First of - I have a Asus P5K WS where I'm running (or actually trying) a
>> raid10 based on 4 sata drives. All drives are connected to esata slot panels
>> which connect to the mainboard ports.
>> The problem I'm encountering is the links to random drives fail every week
>> or so.
>> The strange thing is - the link is often failing for 2 drives at a time -
>> which is the best when running a raid10 *sarcasm*
>> The drives are WD, Samsung and Hitachi - so I think some specific driver
>> failure can be ruled out.
>> I attached the dmesg - perhaps someone could tell me which component is
>> responsible for my drives losing their link.
>
> Looks like a flaky cable, or bad connector.

Or a marginal power supply that can't handle 4 hard drives, a dvd
drive, and whatever else is attached to that system.
