Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZAERsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZAERsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZAERs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:48:28 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:5368 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbZAERs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wlpQO2vmH7ZHuWxH8TYl/l8VFrYSgZn9NvTTxtzvyA9z5lWLUZ/3SOld/JSZOSmu15
         yuC+uHZGQw9ZN0u3ibUQqD/G3s0X0eVT6skNjeCjw3BspBebCR1TEPsetWnC0xJi4dvz
         OgOHDdENCNqzZSDllsBHcUQmQq1ZLwePzqbc8=
Message-ID: <3f9a31f40901050948t6040a2d5nc612f0c1195d1df@mail.gmail.com>
Date: Mon, 5 Jan 2009 23:18:25 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] firmware: Arrange WHENCE in alphabetical order to avoid conflicts
Cc: "Jaswinder Singh" <jaswinder@infradead.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1229861579.22786.32.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229860427.6846.3.camel@jaswinder.satnam>
	 <1229861579.22786.32.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Sun, Dec 21, 2008 at 5:42 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sun, 2008-12-21 at 17:23 +0530, Jaswinder Singh wrote:
>>
>> We are facing problems while we prepare patch for firmware as we add
>> new stuff at the end.
>> As per David Woodhouse suggestion, I am arranging WHENCE to
>> aplhabetical order by driver name to avoid conflicts.
>> Thanks to my son Gurchet Singh to help me in arranging driver names in
>> alphabetical order.
>>
>> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
>
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>
> Now we're trying to push the remaining conversions to request_firmware()
> via the driver authors, putting it into alphabetical order should help
> to avoid the conflicts.
>
> If we could have this in before 2.6.28 (since it's purely cosmetic) or
> immediately thereafter, that would be great.
>

Do you think this patch can merge now or should I wait for merging window.

Thanks
--
JSR
