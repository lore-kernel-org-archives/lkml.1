Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbZEGJeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbZEGJeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbZEGJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:28:42 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:59334 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761445AbZEGJ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:28:41 -0400
MIME-Version: 1.0
In-Reply-To: <m1vdodnx8e.fsf@fess.ebiederm.org>
References: <1241097822.2516.3.camel@poy> <m1vdodnx8e.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 7 May 2009 11:28:19 +0200
Message-ID: <ac3eb2510905070228w5ecb5aa9ob24af17a91d2f231@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 10:17, Eric W. Biederman <ebiederm@xmission.com> wrote:

> sysfs is slow.
> udev is slow.

Everything is "slow" if you want to boot "fast". It's just numbers,
and this is more about simplicity and reliability, with just the side
effect that it's the fastest you can do, when you don't want to lose
current functionality.

> Let's bloat the kernel to solve that problem?

You want to add namespaces for devices to it?

Thanks,
Kay
