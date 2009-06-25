Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZFYRRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZFYRRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZFYRQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:16:54 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:39432 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZFYRQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:16:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KFOC2i8CJZ4ur/H7k/olIF7YIvLBbzuOmWnJDMcQP5gBGVjSGifUiPRgb3B48W55Kj
         XOs/EAJt4ot9hjKub8uCRe1wu+RWZC2fIrAxYpO6zgkSHYiA2YCJpCugN2xNIytAWOwK
         2Knux0taP5pS5aLTd3Mu88ZB0yQtneOU9WzXU=
MIME-Version: 1.0
In-Reply-To: <4A438BA7.9010800@tuffmail.co.uk>
References: <4A438BA7.9010800@tuffmail.co.uk>
Date: Thu, 25 Jun 2009 19:16:53 +0200
Message-ID: <8db1092f0906251016l5ac85bfdpbac841b939cfac2a@mail.gmail.com>
Subject: Re: 2.6.30-rc1: touchpad disabled on hibernation
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/25 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> The synaptics touchpad on my EeePC 701 dies on hibernation.  2.6.30 was
> fine, and it doesn't happen on suspend to ram either.  There are no
> obvious error messages, but maybe this boot message is relevant:
>
> Platform driver 'i8042' needs updating, please use dev_pm_ops
>

Similar on s2disk, HP/Compaq notebook. Try reload psmouse module. I
reported it, but nobody answer.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
