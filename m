Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZDUIet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZDUIet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZDUIei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:34:38 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:61125 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZDUIeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:34:37 -0400
X-Greylist: delayed 89531 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 04:34:37 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RHnEZuNsxdiPc1+oU7NBDsIzw7Vuh/1HRYOzZiWVwbEQIC0PSKpx1QEh+ZH4qLQ5Zx
         ++KIbyJSjFRQfkX+e6byUZmA+gu5MPui/MMRnKOsJhfqoMbRY8x1ZP7UrrsYOh+jYk1i
         QDWL6WZof3r/SQ6o4JcL00R2MfROmtjv3GZy8=
MIME-Version: 1.0
In-Reply-To: <20090421073234.GB4593@kernel.dk>
References: <1240215264-8096-1-git-send-email-a.beregalov@gmail.com>
	 <20090421073234.GB4593@kernel.dk>
Date: Tue, 21 Apr 2009 12:34:36 +0400
Message-ID: <a4423d670904210134i2aa1b6b9xf9d38792b7302044@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/compat_ioctl: fix build when !BLOCK
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/21 Jens Axboe <jens.axboe@oracle.com>:
> On Mon, Apr 20 2009, Alexander Beregalov wrote:
>> From: alexb <alexb@localhost.(none)>
>>
>> In file included from fs/compat_ioctl.c:61:
>> include/linux/loop.h:59: error: field 'lo_bio_list' has incomplete type
>>
>> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>
> Thanks, applied.

Hi Jens

Al has already sent it to Linus.
