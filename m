Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbZHNTjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbZHNTjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932199AbZHNTjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:39:04 -0400
Received: from mail.setcomm.ru ([81.211.32.179]:45310 "EHLO mail.setcomm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbZHNTjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:39:03 -0400
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 15:39:03 EDT
Message-ID: <4A85B601.2090709@kernelpanic.ru>
Date: Fri, 14 Aug 2009 23:07:45 +0400
From: "Boris B. Zhmurov" <bb@kernelpanic.ru>
Reply-To: bb@kernelpanic.ru
User-Agent: Thunderbird 2.0.0.22 (X11/20090630)
MIME-Version: 1.0
To: Tim Tassonis <timtas@cubic.ch>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fix for latest in stable?
References: <4A85593E.4070405@cubic.ch>
In-Reply-To: <4A85593E.4070405@cubic.ch>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Tassonis a écrit :

> Hi
> 
> 
> Is there already a fix for the latest local root exploit in stable?
> 
> 
> 2.6.30.4 is vulnerable and gives me a nice little root shell with this
> exploit:
> 
> http://grsecurity.net/~spender/wunderbar_emporium.tgz


http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e694958388c50148389b0e9b9e9e8945cf0f1b98


-- 
Boris B. Zhmurov
System/Network Administrator
mailto: bb@kernelpanic.ru
"wget http://kernelpanic.ru/bb_public_key.pgp -O - | gpg --import"

P.S. A computer is like air conditioning:
                            it becomes useless when you open windows...

