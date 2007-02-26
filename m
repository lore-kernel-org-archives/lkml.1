Return-Path: <linux-kernel-owner+w=401wt.eu-S1161211AbXBZViw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161211AbXBZViw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161201AbXBZViw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:38:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:46866 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161211AbXBZViv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:38:51 -0500
X-Provags-ID: V01U2FsdGVkX1/BbB0z0fnBvD/7PRADpYnxkU9Hj21luae5gkZ1Rt
	Sv3A==
Date: Mon, 26 Feb 2007 22:38:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] pata_sil680 suspend/resume
In-Reply-To: <Pine.LNX.4.60.0702262150460.5079@poirot.grange>
Message-ID: <Pine.LNX.4.60.0702262233240.5079@poirot.grange>
References: <20061122172841.0b90f042@localhost.localdomain>
 <Pine.LNX.4.60.0702262150460.5079@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007, Guennadi Liakhovetski wrote:

> With an approximately 2.6.20 kernel I could suspend, but on resume I got

Sorry, a "small" correction - it turned out to be a 2.6.19-rc4-ish kernel, 
so, it is still without your suspend / resume patch, hence we can just 
forget it. Remains to clarify why the new one doesn't allow to suspend.

Thanks
Guennadi
---
Guennadi Liakhovetski
