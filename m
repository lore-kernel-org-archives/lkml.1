Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbXLHVir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbXLHVir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXLHVij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:38:39 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:34175 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXLHVii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:38:38 -0500
From: Markus <M4rkusXXL@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: programs vanish with 2.6.22+
Date: Sat, 8 Dec 2007 22:38:28 +0100
User-Agent: KMail/1.9.7
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Simon Holm =?iso-8859-1?q?Th=F8gersen?= <odie@cs.aau.dk>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <200712061906.42070.M4rkusXXL@web.de> <200712081312.14726.M4rkusXXL@web.de> <20071208150637.4eee3e3d@localhost>
In-Reply-To: <20071208150637.4eee3e3d@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712082238.29244.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX19roxq0ZiV9gB+gA1R9FVZKX7uzKwjHzT4UCaVR
	6+DqvkhTbKtjE/Aiw0LQyR0gF7PhGAAtp0PEnC0TVRi0OGWjLd
	05pKno25M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, after that I tried to verify that 22 is really fine. 
Unfortunatelly under heavy load its the same... even with .19 (the 
oldes kernel I have still installed)
I just noticed it, because its harder to produce it on .22 and before. 
You guys tuned the kernel so it was easier.
So it must be something in userspace, please excuse me ;)

Markus
