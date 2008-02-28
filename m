Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbYB1Kn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbYB1Kn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYB1Knv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:43:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:1130 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbYB1Knv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:43:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gUpeTRVrdEVxpJM5+nmNtQlTqO/zRjzTPclOM8uFdgSdqQ7N9I8eRcVdVEGeh9Ea3hXUbxg1IWJoeqkkq4TRj4xJMABNInzYaClWi4dK0Wu6FNCpWNsQEAG7iIam7ez+um1Sb1JEQewu6VwFcD5aDHd9T87++UirbqX/cVV7bu8=
Message-ID: <15577be70802280243l48452cb2vc4405b8b9cc89fed@mail.gmail.com>
Date: Thu, 28 Feb 2008 11:43:50 +0100
From: "Abel Bernabeu" <abel.bernabeu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/ext3/namei.c:383
In-Reply-To: <15577be70802280233n412108exb0a5f03a2405ceca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15577be70802280233n412108exb0a5f03a2405ceca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/28, Abel Bernabeu <abel.bernabeu@gmail.com>:
> My kernel says that has a bug.
>
>  I attach two logs:
>
>  1) The output of dmesg.
>  2) The output printed in my console.
>
>  In defense of Linux I have to admit that I previously used the EXT3
>  filesystem that kernel was trying to access with Windows (by means of
>  an EXT2 driver from http://www.fs-driver.org/).
>

Oh, the version my kernel is 2.6.18, and I am using an x86 PC. I can
supply more data if requested, of course.
