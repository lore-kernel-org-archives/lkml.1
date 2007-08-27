Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbXH0PWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbXH0PWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbXH0PWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:22:10 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:51475 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbXH0PWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k70cBWNxPmGC0HeZ5WVRbv/lrDOiewUjVngfhbUaHND8pfAcPU6StKMGpDONidP6SgvV3ngNeqQDKQEXN4p7WlE//TK/jqXJydP5JWhKym6YlZ5L0eOq3O+YSm/nigB21ut7zpCjvj0B4EA2zDvktcwSDdr8EFzzw3dPYQdudAo=
Message-ID: <6bffcb0e0708270822h3b872bd7tc52b3672777fdf12@mail.gmail.com>
Date: Mon, 27 Aug 2007 17:22:06 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Cc: "Pavel Machek" <pavel@ucw.cz>, rusty@rustycorp.com.au, vatsa@in.ibm.com,
       zwane@arm.linux.org.uk, "kernel list" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070827104350.GA2073@elf.ucw.cz>
	 <20070827105801.GA4053@elf.ucw.cz>
	 <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/08/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On 8/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> > On Mon 2007-08-27 12:43:50, Pavel Machek wrote:
> > > Hi!
> > >
> > > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > > x60, i386 architecture).
>
> I just 3 cycles of on-line/off-line on 2.6.23-rc3 on ThinkPad x60s,
> and my system still survives.

So maybe diff between your and Pavel's config file will give an answer.

Any details about the software environment?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
