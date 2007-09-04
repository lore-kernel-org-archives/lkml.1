Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXIDUuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXIDUuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXIDUus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:50:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:25749 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbXIDUur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:50:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mnFTRgis/Db+xJTUP+8mAVOVlDrap3mrdlFCZX/X3h5FMl/b/y8vRJ6Bu5doOj3xWXCXbzBfWHbhuzEMwslWVXl03SwCFHButhKbeQWd3NdLmU85JJwYLVEM7+/KlLuFWn29pZ9HBOPS9yIqwbQdAoGFMtV7/1UaMTo04LErweE=
Message-ID: <3ae72650709041350s594888c7jbb2e93af9c805f7b@mail.gmail.com>
Date: Tue, 4 Sep 2007 22:50:43 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "davide rossetti" <davide.rossetti@gmail.com>
Subject: Re: origin of __tmp1930643048 network device name: kernel-space or user-space
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com>
X-Google-Sender-Auth: 498a3ce9dd11ed14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/07, davide rossetti <davide.rossetti@gmail.com> wrote:
> I'm trying to track down a problem on a Sun V40Z server with 4 network
> devices grabbing random ethX device names. now, trying to force the
> device names to what I want, I got a __tmpXXXXX form of device name,
> which I think is a half-configured device... but which piece of
> software is to blame ??? kernel, udev, hotplug
>
> it is a Fedora Core 6, fully updated (kernel-2.6.22.2-42.fc6
> udev-095-17.fc6.x86_64)

I don't think any of the mentioned tools is to blame. Please use the
distro's bugtracker.

Thanks,
Kay
