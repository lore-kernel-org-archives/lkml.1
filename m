Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXJXLRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXJXLRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXJXLRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:17:36 -0400
Received: from spiffy.freedom.ind.br ([201.35.65.91]:53701 "EHLO
	freedom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751124AbXJXLRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:17:35 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 07:17:35 EDT
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Build Failure with 2.6.24-rc1
References: <1193221627.5685.2.camel@localhost>
From: Otavio Salvador <otavio@debian.org>
Organization: O.S. Systems Ltda.
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Wed, 24 Oct 2007 08:47:34 -0200
In-Reply-To: <1193221627.5685.2.camel@localhost> (Chris Holvenstot's message of "Wed\, 24 Oct 2007 05\:27\:07 -0500")
Message-ID: <87d4v4ssah.fsf@lab.ossystems.com.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Holvenstot <cholvenstot@comcast.net> writes:

> When attempting to build the 2.6.24-rc1 kernel:
>
>
> arch/x86/kernel/built-in.o: In function `smp_send_nmi_allbutself':
> /build/linux/arch/x86/kernel/crash.c:85: undefined reference to
> `genapic'
> make: *** [.tmp_vmlinux1] Error 1

Use the patch that Ingo sent on Message-ID: <20071024072322.GA2907@elte.hu>

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
