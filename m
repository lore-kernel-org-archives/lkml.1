Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbZHNUgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbZHNUgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932862AbZHNUga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:36:30 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:51372 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbZHNUga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:36:30 -0400
Message-ID: <4A85CAC7.4040606@pardus.org.tr>
Date: Fri, 14 Aug 2009 23:36:23 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable-review@kernel.org
Subject: Re: [patch 00/74] 2.6.30.5-stable review
References: <20090813195705.GA22393@kroah.com> <4A850395.4050204@pardus.org.tr> <20090814161523.GA11228@suse.de> <4A85984A.3050808@pardus.org.tr> <20090814170913.GA21596@suse.de>
In-Reply-To: <20090814170913.GA21596@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Ok, I'll consider these for the next -stable release.
>
> But you do realize it is trivial to add new device ids to the driver
> from userspace with no kernel changes needed, right?  So if you have a
> specific device that you know works with newer kernels, you can just do
> that until your distro updates to a newer kernel.
>   

Yes actually I'm the maintainer of the kernel package, I've already
cherry-picked those. Just noticed you to keep 2.6.30 more up-to-date :)

Thanks,
Ozan
