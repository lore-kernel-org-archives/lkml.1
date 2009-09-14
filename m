Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZINLfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZINLfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZINLfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:35:17 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34135 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbZINLfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=SXo2bOXLFT8+kUHwaQipbST8ZdaOP5RmfEDN9P8H2ST7NZVXMbopJguRCa81j2rMbC
         T5uTrFtyaP9H8EJ8D/uXLPsBQBTswC2n2swU/tWQXQRsrf4WvHpsWj2+Ndg2XdwzF3qc
         vzGtzOV3kwSSsh/HK4nWgTev5AEMYJEGII0Uk=
MIME-Version: 1.0
From: Salvatore Iovene <salvatore.iovene@googlemail.com>
Date: Mon, 14 Sep 2009 14:34:56 +0300
Message-ID: <c64207c00909140434t46d89025yaee72908143f128c@mail.gmail.com>
Subject: /lib/modules/2.6.31-10/build/drivers/input/hid-ids.h - where is it?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<preface>
I know that asking is not good netiquette, but could you please CC me
if you reply? I'm not subscribed because this is really a one time
question. Thanks!
</preface>

Hi,
I have upgraded to Ubuntu 9.10 yesterday, and that brought in the
2.6.31-10 kernel. I always build the linuxwacom drivers myself, and
they use the file in the subject (not 100% sure about the path,
though: I recalled it from memory).
Despite having all the dependencies that allowed me to build
linuxwacom in the past, now that file is missing.

I have searched with apt-file, with no luck. I also have checked that
the file hasn't been deleted from the repositories, as this is its
history:

http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=history;f=drivers/hid/hid-ids.h;hb=ed42350e02bfcb333024949e9653d06916135cc5

So why don't I have it and what should I do to get it?

Thank you very much in advance, and, once again, please CC me in your reply.
Appreciated.

-- 
Salvatore Iovene
http://www.iovene.com/
http://www.geekherocomic.com/
