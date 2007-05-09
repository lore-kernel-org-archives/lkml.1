Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbXEITXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbXEITXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXEITXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:23:04 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41206 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbXEITXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:23:01 -0400
Message-ID: <46421F3D.7060401@zytor.com>
Date: Wed, 09 May 2007 12:21:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: ebiederm@xmission.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       vgoyal@in.ibm.com, yhlu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <4634483E.9030307@goop.org> <4640FB2C.2060300@zytor.com> <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com> <46410403.4050802@zytor.com> <m17irivkhy.fsf@ebiederm.dsl.xmission.com> <46413087.2020505@zytor.com> <m1tzumu10k.fsf@ebiederm.dsl.xmission.com> <86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com> <46415640.6000600@zytor.com> <4641573C.1000205@zytor.com> <86802c440705082248r5248aa08s8299e03f615b984a@mail.gmail.com> <46416246.9090005@zytor.com> <m1abwetgkn.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abwetgkn.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com wrote:
> 
> Well in this case things are so very much better then attempting to
> us setup.S it isn't a real option.
> 

Obviously not, but it was more of a comment on the apparent assumption
that doing so would be simple.

	-hpa
