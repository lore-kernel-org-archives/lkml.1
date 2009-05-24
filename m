Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZEXV5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZEXV5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 17:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZEXV5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 17:57:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53877 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZEXV5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 17:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JzgwvgLUtGQTlaKzqU5wiSwH8+YnqM/Qo4lkv3wh0RKJcwY8PtlA9tvkF+6IM+UdBQ
         jtOtDpKYeq8IO+iTeTzW4PjVi5fpwsS5PR/EqECdyYgWon8R1eXVE5D/o105X6rRLbjd
         Eo+S27BKOQqaQPy0UvW5m+srrbZW0JX1jkwdw=
Message-ID: <4A19C2A3.6030501@gmail.com>
Date: Sun, 24 May 2009 23:56:51 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: Re: 2 bugs related to suspend to disk
References: <4A199A7A.3010705@gmail.com> <20090524205450.GA1693@elf.ucw.cz>
In-Reply-To: <20090524205450.GA1693@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> 
>> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
>>
> 
> I'm afraid we need more details here. Is "resume" binary being ran?

Excellent question ;) - I didn't know it has to. I'll try to setup
initramfs tomorrow.

Thanks and sorry for the noise!

Marcin
