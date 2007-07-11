Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbXGKArL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbXGKArL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXGKAq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:46:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbXGKAq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:46:57 -0400
Message-ID: <4694287A.5080203@zytor.com>
Date: Tue, 10 Jul 2007 17:46:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
References: <200707081336.27985.a1426z@gawab.com>
In-Reply-To: <200707081336.27985.a1426z@gawab.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> 
> Try this "[PATCH] initramfs: Allow rootfs to use tmpfs instead of ramfs".
> 
> It's trivial and should be in mainline.
> 

Simple, yes, trivial, no.

It should be pushed to -mm before mainline to give it some smokeout time.

	-hpa
