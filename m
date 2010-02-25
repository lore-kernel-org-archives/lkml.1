Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0BYEoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:44:11 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:54393 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab0BYEoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=x+y2tPaKKOkKJlUmTEvesANNRlJfFuIZaSKIAYsIt2NHEB3dFseeUgV6qTX8mPNjuQ
         Weyz7rsdizgPrTmkcB45ZOzZFTsb/teTWC22O5c0NPQ/xGxPy/1CSygGphTA/XmB66RG
         BQqXiefIHcNmFwp9c5xhQ0FqbG/35mYEnnGpo=
MIME-Version: 1.0
In-Reply-To: <20100222141934.GA9030@darkstar>
References: <20100222141934.GA9030@darkstar>
Date: Thu, 25 Feb 2010 10:14:08 +0530
Message-ID: <3f9a31f41002242044j597a9f43m134487d2d8588c6c@mail.gmail.com>
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Mon, Feb 22, 2010 at 7:49 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> hexdump stuff in kernel.h should be put into a standalone head file
>
> cleanup hexdump declarations in kernel.h, put them into hexdump.h
> include hexdump.h in every file which need it
>

Can we include hexdump.h in kernel.h instead of including in every file.

Thanks,
--
Jaswinder
