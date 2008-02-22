Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYBVR4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYBVR4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYBVR4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:56:44 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:44275 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYBVR4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:56:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Fri, 22 Feb 2008 18:56:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de> <47BF0BA4.5060503@googlemail.com>
In-Reply-To: <47BF0BA4.5060503@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802221856.14980.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008 18:51:32 Gabriel C wrote:
> > I'm not going to play these kconfig SELECT tricks anymore.
> 
> Fix it different then.

Please do so.

> Yes it is but that is still not a valid reason to NACK that patch , I'm sorry.

NACK means I (being the maintainer of the modified code) won't
sign-off this patch. Nothing more or less. If some upstream maintainer
decides to bypass me and apply the patch nevertheless is not of
my business. But I will not sign-off or ack this patch.

-- 
Greetings Michael.
