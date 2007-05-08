Return-Path: <linux-kernel-owner+w=401wt.eu-S1032723AbXEHXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032723AbXEHXNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031772AbXEHXNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:13:39 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031630AbXEHXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:13:38 -0400
Message-ID: <46410403.4050802@zytor.com>
Date: Tue, 08 May 2007 16:13:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: yhlu <yhlu.kernel@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@in.ibm.com,
       Gerd Hoffmann <kraxel@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <4634483E.9030307@goop.org>	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>	 <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com>	 <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>	 <4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com> <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
In-Reply-To: <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yhlu wrote:
> On 5/8/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> Jeremy Fitzhardinge wrote:
>> Specifically boot_params.screen_info isn't being properly set up by the
>> caller.
> 
> will setup real_mode_data in kexec path?

-ENOPARSE

	-hpa
