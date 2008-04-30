Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYD3Drk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYD3Drk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYD3Dra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:47:30 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:31850 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYD3Dr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:47:29 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 23:47:29 EDT
Date: Tue, 29 Apr 2008 22:38:01 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080430033800.GA1439593@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430000851.GH4818@implementation>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Samuel Thibault  <samuel.thibault@ens-lyon.org> said:
>Try init=/bin/sh, from that shell run stty iutf8. Then things will work
>fine.  The fix is thus just to make the VT's tty initial iutf8 setup
>follow vt.default_utf8.

You may also need to select a UTF-8 locale (e.g. LANG="en_US.UTF-8") for
programs like bash to handle this correctly.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
