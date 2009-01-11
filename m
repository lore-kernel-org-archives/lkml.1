Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZAKCuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZAKCuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZAKCuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:50:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZAKCuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:50:46 -0500
Message-ID: <49695E5B.3060308@zytor.com>
Date: Sat, 10 Jan 2009 18:50:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alain Knaff <alain@knaff.lu>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PULL] bzip2/lzma kernel compression
References: <200901091845.n09IjBsT003630@terminus.zytor.com> <86802c440901091252r2eab513dnf048851aea505d8d@mail.gmail.com> <86802c440901091343p6797536bxf73107fa1672d29b@mail.gmail.com> <20090111024756.GB7077@elte.hu>
In-Reply-To: <20090111024756.GB7077@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> was the linux/.lzma file corrupted, and once you removed the stale file it 
> all works fine and the problem does not come back?
> 
> I.e. the tree as offered by hpa is fine?
> 

That was the understanding I got.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

