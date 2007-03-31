Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbXCaILe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbXCaILe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXCaILe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:11:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:22624 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbXCaILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lY3uHMeV+m6lFFSvQsRwuDrCgrv0RIBfp/LXv5TbT2zrf4ZNfm329cJlGJfztjuv4my0JIordHLrc+RkZLUlUbtzHD/e5sLTzHr2r/60XQmTWZwPFHhKaPdzLjSp8v3Z5BtvfXIp7lErP5V9rbzQ7NJKpv5VBZR0I2UHIsLUkfc=
Message-ID: <9c9aa5d00703310111w3809fd56t75bcde9d5047ca81@mail.gmail.com>
Date: Sat, 31 Mar 2007 01:11:29 -0700
From: "Pedram M" <pmessri@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: kswapd issues + kernel 2.4.21-32.0.1.ELsmp
In-Reply-To: <9c9aa5d00703310110s2a21f19l37544c3d46be53c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c9aa5d00703310110s2a21f19l37544c3d46be53c9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've seen this around, and have heard about it in forums and else-where,
could somebody enlighten me with more information or with experiences
they have had.  Looks like kswapd begins to eat CPU dramatically till the
box eventually locks up.

Thanks,
Pedram
