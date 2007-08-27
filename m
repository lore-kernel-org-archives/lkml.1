Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXH0OhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXH0OhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 10:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXH0Og7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 10:36:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:11717 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXH0Og7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 10:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lJsZIEq0BM7IthMg9KcWYePlufmvl9d4tA1X2QMzH5xAuISwRYJDGPOQcfrS+lLeZGuARkpCT1KijPT8r4eeT/4FrwC7OkBR0cxcxU4qrSQR4vCeBbfCOdV14BSNYNJRfy75sxYMRvFl7h48KYPJRgJLDK8HwGLg5NfphvEFlBI=
Message-ID: <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com>
Date: Mon, 27 Aug 2007 22:36:57 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070827105801.GA4053@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070827104350.GA2073@elf.ucw.cz>
	 <20070827105801.GA4053@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2007-08-27 12:43:50, Pavel Machek wrote:
> > Hi!
> >
> > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > x60, i386 architecture).

I just 3 cycles of on-line/off-line on 2.6.23-rc3 on ThinkPad x60s,
and my system still survives.

Jeff.
