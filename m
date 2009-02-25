Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbZBZACe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbZBZACe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZBZABx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:01:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60074 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZBZABv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:01:51 -0500
Message-Id: <20090225235138.062045835@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:51:38 +0100
From: arnd@arndb.de
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [patch 0/7] Use strict kernel types to fix the world
X-Provags-ID: V01U2FsdGVkX19TRtD7miUHthiZikEIsLZKm1ljzieyEmqlHRp
 hzvzJKGVWFU3SHLEvkcxuYvpwc2OKz4GbsnkjrJSGLhubD4Rl8
 l53aFfye05mDb8R6LbcGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've gone through the files again and fixed up all
non-strict types I could find. I did not check all
architectures for this though.

I split out netfilter, DRM and MTD, because of both
size and potentially controversial changes.

	Arnd <><

