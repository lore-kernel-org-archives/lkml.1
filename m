Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZEEKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZEEKLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZEEKLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:11:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:46186 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753495AbZEEKLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:11:03 -0400
X-Authenticated: #54312696
X-Provags-ID: V01U2FsdGVkX18zciwejaAzLumY/672B36AMIp8Xapm3A9QguwcaC
	O1/JYkw3BOl5BF
Date: Tue, 05 May 2009 12:11:01 +0200 (CEST)
Message-Id: <20090505.121101.258772493.wl@gnu.org>
To: linux-kernel@vger.kernel.org
Cc: opensuse-kernel@opensuse.org
Subject: Re: some kernel issues
From: Werner LEMBERG <wl@gnu.org>
In-Reply-To: <20090504.182628.216265620.wl@gnu.org>
References: <20090503.132958.227862405.wl@gnu.org>
	<20090504.182628.216265620.wl@gnu.org>
X-Mailer: Mew version 6.2.50 on Emacs 22.3.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [kernel 2.6.30-rc4-14-vanilla from openSuSE factory on top of
> openSuSE 11.1]
> 
> 
> With my 945GM intel graphics card, I don't get TTYs which I could
> switch to with Ctrl-Alt-Shift-F1, for example, after X has started.
> Only F7 to switch back to graphics mode works fine.  In particular,
> I don't see any boot messages at start-up.  This has worked fine
> with a previous kernel like 2.6.27.21.

I've filed a bug report.

  http://bugzilla.kernel.org/show_bug.cgi?id=13249


     Werner
