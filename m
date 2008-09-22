Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbYIVMGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbYIVMGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYIVMGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:06:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:28203 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYIVMGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=U/+n9drbhyjHK3hlkTUI1RWe1lowZrw0xuDmJ2exPxMzy9RjbBqRtrD+cTjeEpl+sj
         qfco0R/kj7adcLB3lrUX+D6BcTC3M9/rbSOlmChDTTi1qznabzXWclBnN4Epk6YEf1S4
         FrhnInrzI6r917Hh9ma12TtwZnfCxeSAPo+4M=
Message-ID: <c62985530809220506o39264e63k25ccb7a73384335c@mail.gmail.com>
Date: Mon, 22 Sep 2008 14:06:44 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Patch 1/3] Tracing/ftrace: Make nop tracer reset previous entries
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Steven Noonan" <steven@uplinklabs.net>
In-Reply-To: <20080922093604.GA17258@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48D68E06.50504@gmail.com>
	 <20080922121237.13D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080922093604.GA17258@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/22 Ingo Molnar <mingo@elte.hu>:
>
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> your patch seems corrupted.
>> please check again your e-mail client settings.
>
> i fixed the extra newlines up and applied the patches to
> tip/tracing/ftrace, thanks Frédéric!
>
> please check Documentation/email-clients.txt about details. There were
> two problems i saw: overlong lines in the commit description and extra
> 'double newlines' in the patch itself. (To get around gmail limitations
> you can send -tip patches as MIME attachments as well.)
>
>        Ingo
>

Oops. I'm really sorry about that. I was pretty convinced that my
email client was well configured.
In the future I will first send myself the patches before any new
submit to ensure they are not damaged...

Thanks.
