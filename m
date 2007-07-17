Return-Path: <linux-kernel-owner+w=401wt.eu-S1765396AbXGQNME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765396AbXGQNME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbXGQNLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:11:55 -0400
Received: from smtp19.orange.fr ([80.12.242.17]:56546 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXGQNLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:11:54 -0400
X-ME-UUID: 20070717131152912.DEDB51C000A2@mwinf1912.orange.fr
From: David CHANIAL <david.ml@euro-web.fr>
Organization: Euro Web
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
Date: Tue, 17 Jul 2007 15:11:43 +0200
User-Agent: KMail/1.9.5
Cc: Neil Brown <neilb@suse.de>
References: <200707160638.15750.david.ml@euro-web.fr> <18076.42052.961808.528867@notabene.brown>
In-Reply-To: <18076.42052.961808.528867@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707171511.43621.david.ml@euro-web.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 juillet 2007 13:13, Neil Brown a écrit :
> What is "-sdf88-core" ?? Are there any extra patches that we should
> know about?

I have upgraded to 2.6.22.1-sdf90-intel
-sdf90 is a set of a configuration with one little patch :
	http://www.ssi.bg/~ja/#hidden

intel or core juste say for wich CPU it was compiled (the previous 
kernel "core" was named-error, the kernel really was for a intel (and not 
core2) cpu)


>    1/ if possible, run memtest86 on the machine for a while, to make
>       sure there isn't a problem with the memory.
>    2/ If the problem happens again, post another report with all the
>       "oops" information again.  Maybe the next time it will be slightly
>       different and will make more sense in some way.

Since the kernel update, no crash anymore - for the moment -.
If it re-crash i will floow this advices.

Thanks Niel,
-- 
David

