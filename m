Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZJHIuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZJHIuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZJHIux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:50:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:48676 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755394AbZJHIuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:50:52 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1/oy90EFhPo998wEy/KkT4F/N2yyNhY4FemPq58lf
	menQnH4HkGe/Cv
From: "Jan-Simon =?iso-8859-1?q?M=F6ller?=" <dl9pf@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: TM6010 driver and firmware
Date: Thu, 8 Oct 2009 10:50:02 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: =?iso-8859-1?q?D=EAnis_Goes?= <denishark@gmail.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f326ee1a0910030539pd5e00e2xb9f6de9975b64b9b@mail.gmail.com> <f326ee1a0910030602w2518f66q2d6e185c473d5ad@mail.gmail.com> <20091005095343.6b9afa65@pedra.chehab.org>
In-Reply-To: <20091005095343.6b9afa65@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081050.02215.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

Using the 3.7 firmware on HVR900H, I get up to this point:

http://pastebin.ca/1603643

[...]
Error during zl10353_attach!
tm6000: couldn't attach the frontend!
xc2028 4-0061: destroying instance
tm6000: Error -1 while registering
tm6000: probe of 1-5.1:1.0 failed with error -1
usbcore: registered new interface driver tm6000
Original value=255


Best,
Jan-Simon
