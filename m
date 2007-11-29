Return-Path: <linux-kernel-owner+w=401wt.eu-S934612AbXK2XdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612AbXK2XdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934403AbXK2Xc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:32:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:27902 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267AbXK2Xc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:32:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EfynD93f25VZNh9eU7zBY5c158WEoGjH5oSYYYR/ZEeDv4dt41o+C6x5gFrs0tK5LlblsPVXz6uYPOEZLYBLLvvuA7mCoEd8aWkJ9RjSk1Ta1oBzcaKnwsFDMXLqFjfytebmELrLt5j2vYKqtRSrK9f1SCrw+Ip1wlr98d8+N9Y=
Message-ID: <5501535d0711291532u1ea214f9n7c47aa175892962d@mail.gmail.com>
Date: Fri, 30 Nov 2007 00:32:55 +0100
From: "Bjoern Olausson" <lkmlist@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata NCQ blacklist entry
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <474F43C0.6080008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>
	 <4731B5DD.1060203@gmail.com>
	 <5501535d0711290917r16a16b0dx36669de89f829231@mail.gmail.com>
	 <474F43C0.6080008@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/07, Tejun Heo <htejun@gmail.com> wrote:
>
> I now have affected drives on my desk and am gonna try reproduce it.  My
> gut feeling says it's timing related problem on controller / driver
> side.  Please wait a bit.
>

> > by the way, and OT, did the Plextor DVD-RW drive reach you, Tejun?
>
> No, not yet.  Do you have a tracking number or something?
>
> Thanks.
