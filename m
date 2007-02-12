Return-Path: <linux-kernel-owner+w=401wt.eu-S965307AbXBLS6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307AbXBLS6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXBLS6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:58:20 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:59880 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965307AbXBLS6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:58:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XXs0JJXIjxkJEFu5EeKhsYX/eDi15mrGdKcXrYSFr+7FPXwFqzv4iyMAW0x2Dle6CyZrc8NqjY0oHZ9mUDSl7AWlAFFqARjeJr0efaOJd9JkJ7POz7elhrvl0p4vWI02iFFKeWVPNW2JTQWDAV3kAZGgrEf36WdDGgQ+35sJO/w=
Message-ID: <b6a2187b0702121058p2dc0681fv47dc412c4f7a6424@mail.gmail.com>
Date: Tue, 13 Feb 2007 02:58:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: [QUESTION] file access time in millisecond?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45d03af4$0$326$e4fe514c@news.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
	 <p73bqjzhhp7.fsf@bingen.suse.de>
	 <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>
	 <45d03af4$0$326$e4fe514c@news.xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Feb 2007 10:01:24 GMT, Miquel van Smoorenburg <miquels@cistron.nl>

> Check out /usr/include/bits/stat.h

Mike,

Thanks for the pointer. Got it. But as I mentioned to Andi, it doesn't
work with my filesystems (ext2, reiserfs). But at least it save me
from upgrading my glibc!


Thanks,
Jeff.
