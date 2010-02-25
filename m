Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0BYHEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 02:04:37 -0500
Received: from mail-iw0-f202.google.com ([209.85.223.202]:58098 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab0BYHEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 02:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NDVm03Xeez47LMNHDZ4SxFQs6TpJURyulqxXJVWoD+PjEnIUZMWa1L9zSXgyRI22bP
         p/kcSk9fq/URmna7w9thNFhybo2b9ysmeq9lOXYXOV62ouMQShE09ZST/d1b55h1dFDv
         g53hU7blYGoWocCu/4AnZVR1ocFyyp1zZWzs8=
MIME-Version: 1.0
In-Reply-To: <3f9a31f41002242044j597a9f43m134487d2d8588c6c@mail.gmail.com>
References: <20100222141934.GA9030@darkstar>
	 <3f9a31f41002242044j597a9f43m134487d2d8588c6c@mail.gmail.com>
Date: Thu, 25 Feb 2010 09:04:35 +0200
Message-ID: <b6fcc0a1002242304k6bd86adbw8b32ed5b46273311@mail.gmail.com>
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 6:44 AM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Can we include hexdump.h in kernel.h instead of including in every file.

Can we include everything in kernel.h?
