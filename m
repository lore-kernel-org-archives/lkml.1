Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbZKTSkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbZKTSkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZKTSkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:40:02 -0500
Received: from fifo99.com ([67.223.236.141]:53663 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZKTSkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:40:01 -0500
Subject: Re: Allow selecting MSM framebuffer in Kconfig
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Iliyan Malchev <malchev@google.com>, dwalker@codeaurora.org
In-Reply-To: <20091120113915.GA5154@elf.ucw.cz>
References: <20091120113915.GA5154@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 10:40:07 -0800
Message-ID: <1258742407.20541.15.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 12:39 +0100, Pavel Machek wrote:
> Allow user to select MSM framebuffer support in Kconfig.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 

Ok, applied. All four patches should be in -next .. Also could you send
patches to dwalker@codeaurora.org from now on?

Daniel

