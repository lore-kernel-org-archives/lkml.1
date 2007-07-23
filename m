Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXGWGsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXGWGsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758985AbXGWGrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:47:55 -0400
Received: from gw.goop.org ([64.81.55.164]:41590 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbXGWGry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:47:54 -0400
Message-ID: <46A44EE7.2030300@goop.org>
Date: Sun, 22 Jul 2007 23:47:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: jeremy@xensource.com, chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.23 patch] xenbus_xs.c: fix a use-after-free
References: <20070723010204.GT26212@stusta.de> <20070723011135.GU26212@stusta.de>
In-Reply-To: <20070723011135.GU26212@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes an obvious use-after-free spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>   

OK, thanks.

    J
