Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbXHTVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbXHTVe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXHTVev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:34:51 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:55774 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbXHTVeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:34:50 -0400
Subject: Re: [PATCH] kexec: reenable HPET before kexec
From: Daniel Walker <dwalker@mvista.com>
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46CA035A.5050202@ru.mvista.com>
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	 <46CA035A.5050202@ru.mvista.com>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 14:31:04 -0700
Message-Id: <1187645464.7732.43.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 01:10 +0400, Konstantin Baydarov wrote:
> Konstantin Baydarov wrote:
> > Hi, I've faced problem:
> > I have two x86_64 kernels with HPET enabled:
> > kernel 1 - with PM enabled,
> > kernel 2 - with PM disabled.
> >   
> Forgot to say that it's RT kernel, version is 2.6.23-rc2-rt2.

It was in your original email ..  Are you saying this it is not a
problem in plain 2.6.23-rc2? I thought I read that it was a problem on
i386 ..

Daniel

