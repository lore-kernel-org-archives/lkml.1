Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbXKFUNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbXKFUNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbXKFUNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 15:13:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbXKFUNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:13:21 -0500
Message-ID: <4730CAD8.1050407@zytor.com>
Date: Tue, 06 Nov 2007 12:13:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] init: Introduce rootdir bootparm to select which dir
 to sys_chroot
References: <200711061340.26112.a1426z@gawab.com> <200711072310.20715.a1426z@gawab.com>
In-Reply-To: <200711072310.20715.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Al Boldi wrote:
>> This patch introduces a rootdir kernel boot parameter, which specifies the
>> path to the kernel sys_chroot boot dir.
>>
>> This is useful for systems that have more than one distribution installed
>> on the same fs/partition.

This seems like something that should be done via an initramfs.

	-hpa

