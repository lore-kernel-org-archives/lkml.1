Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbZEELCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbZEELCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbZEELC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:02:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:43877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754106AbZEELC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:02:26 -0400
X-Authenticated: #54312696
X-Provags-ID: V01U2FsdGVkX19zVF0RVDhzmCpxLwq2KPVDKAxhGJPU/9zgUu7EQ8
	LEg3+JrL7h/rLF
Date: Tue, 05 May 2009 13:02:25 +0200 (CEST)
Message-Id: <20090505.130225.42780711.wl@gnu.org>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: some kernel issues
From: Werner LEMBERG <wl@gnu.org>
In-Reply-To: <21d7e9970905050344x2a92f9c6l8569b68bff905370@mail.gmail.com>
References: <20090503.132958.227862405.wl@gnu.org>
	<20090504.182628.216265620.wl@gnu.org>
	<21d7e9970905050344x2a92f9c6l8569b68bff905370@mail.gmail.com>
X-Mailer: Mew version 6.2.50 on Emacs 22.3.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@gmail.com>
Subject: Re: some kernel issues
Date: Tue, 5 May 2009 20:44:18 +1000

>> With my 945GM intel graphics card, I don't get TTYs which I could
>> switch to with Ctrl-Alt-Shift-F1, for example, after X has started.
>> Only F7 to switch back to graphics mode works fine.  In particular,
>> I don't see any boot messages at start-up.  This has worked fine
>> with a previous kernel like 2.6.27.21.
> 
> Make sure you haven't enabled kernel mode setting.
> 
> CONFIG_DRM_I915_KMS

Uuuuh, completely undocumented.  Thanks!  Will check soon.


    Werner
