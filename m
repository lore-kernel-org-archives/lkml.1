Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXJURvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXJURvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 13:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXJURvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 13:51:15 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:31568 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXJURvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 13:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ENPfo8t3QTyvrIqp0NC1i+K5VDiHakJkOfRGXHtcyMLwKegYQAHHR9ED0tA/TLrdSTUktdX4JynKL1eR/BCfInChQ3C9HzTqLQJBqRPjAs7q0Xq4m29ZaqRBisSIAOuLYX4AYJv2ryj12p8+3mzt5AvDVj3XRvWenvXAMlpDZ98=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-2?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH 1/3] leds-clevo-mail: export i8042_command()
Date: Sun, 21 Oct 2007 13:51:07 -0400
User-Agent: KMail/1.9.7
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Rodrigo Pereira <rodripe@gmail.com>
References: <4718FCE6.204@freemail.hu>
In-Reply-To: <4718FCE6.204@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710211351.07422.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 19 October 2007, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Export the i8042_command() function which manages the mutual exclusion
> with the help of the i8042_lock spinlock. This lets possible to use the
> i8042 hardware safely from other part of the kernel, too.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Thanl you for reminding me of this patch. I will apply it, however
I expect the other 2 to come through Richard's tree.

Thank you.

-- 
Dmitry
