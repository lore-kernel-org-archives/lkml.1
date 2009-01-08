Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbZAHGM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbZAHGM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZAHGMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:12:44 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:53070 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZAHGMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tLErKNrFMGkIyIZcWMj8Yv65AxL93GeKvT0B23zzOyEUDbL6ODrySBHNOGRlxilF43
         /8ztNDFvJn7zc7IwE6irzjvSPQtu4qVEhpEsXt4fpDGuKB0/fEijawvutr37EKfiZbHd
         tBNdVSetoKRqfUJaoeUR7gauXwTH0kWoqdQ84=
Message-ID: <3f9a31f40901072212x41e405fh7e36f6adb927814b@mail.gmail.com>
Date: Thu, 8 Jan 2009 11:42:42 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading (-git7 is ok)
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <5a4c581d0901070624t6e769966t6b034b14d4732bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0901070624t6e769966t6b034b14d4732bd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello alessandro,

On Wed, Jan 7, 2009 at 7:54 PM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
>
> Note that I don't have CONFIG_FIRMWARE_IN_KERNEL, but on
>  the other hand I didn't earlier, either... and yes, CONFIG_MODULES=y.
>

Please try with CONFIG_FIRMWARE_IN_KERNEL , is this makes some difference.

--
JSR
