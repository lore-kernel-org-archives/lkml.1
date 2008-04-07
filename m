Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYDGLWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYDGLWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYDGLWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:22:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8884 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYDGLWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UPQIfR13wwJrJQ72TFKzmSPcaIddeWAjdDleGxWdVpZiu2VK7jN836NjyC5UEsYj0ZAzaOQrc67szgYFYZqT7PTdg3SMEa2Et4rPUyyhnq1usWLib8yH3ekRMA3g6YFgyx4trdZHqNlKNwi91TizLezErZT2IY+A/6dXuNtEHgk=
Message-ID: <efeafa350804070422p7508073fkb40ffe9283464a71@mail.gmail.com>
Date: Mon, 7 Apr 2008 13:22:07 +0200
From: Lazy <lazy404@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: 2.6.24.4 compilation error
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47FA012C.7000509@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <efeafa350804070321ka6cbb46pd49a62fc325eb4e0@mail.gmail.com>
	 <47FA012C.7000509@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/7, Gabriel C <nix.or.die@googlemail.com>:
> Lazy wrote:

>  > kernel/built-in.o: In function `update_wall_time':
>  > (.text+0x23796): undefined reference to `__umoddi3'
>  > kernel/built-in.o: In function `update_wall_time':
>  > (.text+0x237b6): undefined reference to `__udivdi3'
>  > make: *** [.tmp_vmlinux1] Error 1
>
>
>
> You'll need this patch :
>
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=38332cb98772f5ea757e6486bed7ed0381cb5f98


thank You
