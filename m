Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbXEJAxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbXEJAxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXEJAxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:53:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50377 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXEJAxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:53:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       vgoyal@in.ibm.com, yhlu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4634483E.9030307@goop.org> <4640FB2C.2060300@zytor.com>
	<86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	<46410403.4050802@zytor.com>
	<m17irivkhy.fsf@ebiederm.dsl.xmission.com>
	<46413087.2020505@zytor.com>
	<m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
	<86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com>
	<46415640.6000600@zytor.com> <4641573C.1000205@zytor.com>
	<86802c440705082248r5248aa08s8299e03f615b984a@mail.gmail.com>
	<46416246.9090005@zytor.com>
	<m1abwetgkn.fsf@ebiederm.dsl.xmission.com>
	<46421F3D.7060401@zytor.com>
Date: Wed, 09 May 2007 18:52:42 -0600
In-Reply-To: <46421F3D.7060401@zytor.com> (H. Peter Anvin's message of "Wed,
	09 May 2007 12:21:33 -0700")
Message-ID: <m11whpts85.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Obviously not, but it was more of a comment on the apparent assumption
> that doing so would be simple.

Reasonable comment then.

Eric
