Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbYC2NjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbYC2NjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 09:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYC2NjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 09:39:15 -0400
Received: from mail.suse.de ([195.135.220.2]:41020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbYC2NjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 09:39:15 -0400
Message-ID: <47EE467E.3060209@suse.de>
Date: Sat, 29 Mar 2008 14:39:10 +0100
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fix iomem misannotations in nozomi
References: <E1JfRRM-0002lF-K0@ZenIV.linux.org.uk>
In-Reply-To: <E1JfRRM-0002lF-K0@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro schrieb:
> aka if you see a force-cast, be very suspicious...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Very nice catch, thanks. I tested this change and its
- as obvious - ok.

Acked-by: Frank Seidel <fseidel@suse.de>
