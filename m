Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZBGRLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZBGRLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZBGRKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:10:55 -0500
Received: from smtp.regionline.fi ([85.157.255.99]:34799 "EHLO
	smtp.regionline.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZBGRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:10:54 -0500
X-Greylist: delayed 730 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Feb 2009 12:10:54 EST
From: Jan Knutar <jk-lkml@sci.fi>
To: "J.A. =?iso-8859-1?q?Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: SSD and IO schedulers
Date: Sat, 7 Feb 2009 18:58:39 +0200
User-Agent: KMail/1.10.4 (Linux/2.6.27.12-170.2.5.fc10.x86_64; KDE/4.1.4; x86_64; ; )
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090204004003.26068f72@werewolf.home>
In-Reply-To: <20090204004003.26068f72@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902071858.40146.jk-lkml@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, J.A. Magallón wrote:

> Perhaps the reason is that, as the SSD is not so good, it behaves
> more like a rotational drive ;).

Do any other SSDs except Intel's exist that DON'T behave more like a 
rotational drive? I am guessing using something like LogFS would give 
the biggest boost on cheap SSDs and all memory cards.
