Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXE1UMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXE1UMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXE1UMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:12:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37825 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbXE1UMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:12:08 -0400
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, video4linux-list@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>
References: <2172422218943432279@wsc.cz>
	 <1180364420.21547.160.camel@localhost>
	 <d9def9db0705280814h8fbd0b7qaf8b324ff20e83d6@mail.gmail.com>
	 <1180378677.21547.189.camel@localhost>
	 <d9def9db0705281217t514462e1wef412de7a9c81826@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 May 2007 17:11:11 -0300
Message-Id: <1180383071.21547.230.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > As Luca pointed, if we add conversion for one driver, we should add for
> > the rest.
> >
> > Instead, it would be better if Jiri sends the decoding and the rescaling
> > stuff as a patch to v4l2-apps/lib, starting the API decoding library.
> > Once we have a library, we can ask the userspace developers to use it
> > for the formats not recognized by their userspace apps.
> >
> 
> I think it would be better to evaluate existing solutions (eg. libpw).

Agreed. Volunteers?

-- 
Cheers,
Mauro

