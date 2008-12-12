Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYLLQXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYLLQXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYLLQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:23:31 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:44631 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYLLQXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bPwcpQUui1EorwP6u9SV5b8eXbNvVarUieCtmoQv0g1rCPu6v8sx6T7z1NIE28ECOs
         Y1cvg6S7+a6rxLjbnDGKlcYdgr2byrp/S5Y3kFgM75mntrmJHtN7MV6hqSLGpUb7YGfx
         pN51q6AvhW9FNlpH03j3pGnMEGQXef/JJT+Wg=
Message-ID: <f5cc88f60812120820i4252962er2fa6d3483c2ae412@mail.gmail.com>
Date: Fri, 12 Dec 2008 14:20:22 -0200
From: "Marcello Henrique" <faraohh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Auto generate .config.
In-Reply-To: <49428DF8.2090205@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f5cc88f60812120747w47c762a7qcee62fdfa10d6ac6@mail.gmail.com>
	 <49428DF8.2090205@diamondcut.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 14:14, Renato S. Yamane
<yamane@diamondcut.com.br> wrote:
> Marcello Henrique wrote:
>> How make to generate the file .config from my distribution to compile
>> new optimized kernel?
>
> Marcello, default .config file of your distro can be founded in /boot
> directory in something like this: "config-2.6.26".
>
> Just rename it to .config and move it to your kernel source directory.
>
> Best regards,
> Renato

Hello Renato,
	
I understand that this is possible, but would not be possible to
generate one .config of modules that are running to compile a kernel
optimized?

The idea is that the kernel of my distribution is too fat and I only
generate a kernel module that I use automatically from a kernel fat.
understand?

I thank in advance.
-- 
Marcello Henrique
Associação Software Livre de Goiás (www.aslgo.org.br)
Cercomp - UFG (www.cercomp.ufg.br)
