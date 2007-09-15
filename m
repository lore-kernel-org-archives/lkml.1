Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbXIOOFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbXIOOFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 10:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXIOOFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 10:05:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51560 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXIOOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 10:04:59 -0400
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Johannes Stezenbach <js@linuxtv.org>, Steven Toth <stoth@hauppauge.com>,
       Manu Abraham <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <d9def9db0709150638o2e4026fbgd347eefc0fa4b3e6@mail.gmail.com>
References: <46E95C54.4060502@gmail.com> <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <20070914204343.GA9058@linuxtv.org>
	 <d9def9db0709141829w449eb9eek9b7b6a714793cede@mail.gmail.com>
	 <20070915131650.GA12531@linuxtv.org>
	 <d9def9db0709150638o2e4026fbgd347eefc0fa4b3e6@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 11:04:42 -0300
Message-Id: <1189865082.5271.91.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Everyone knows that there are some issues even some internal
> ones which I'm not part of.

With respect to your kernel-userspace API for xc3028, you made something
that seemed to be a dream: there's a consensus: not a single developer
believed that this is the better way; nobody seems that this is the
better approach.

So, or you are the only media developer with good sense in the face of
the Earth, or you're incapable of understand the obvious: you're wrong
with this approach. IMO, the answer is quite obvious.

-- 
Cheers,
Mauro

