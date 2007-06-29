Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbXF2Izp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbXF2Izp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbXF2Izi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:55:38 -0400
Received: from relay4.usu.ru ([194.226.235.39]:36300 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXF2Izh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:55:37 -0400
Message-ID: <4684C91B.5060203@ums.usu.ru>
Date: Fri, 29 Jun 2007 14:55:55 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Bill Davidsen <davidsen@tmr.com>, rob@landley.net,
       linux-kernel@vger.kernel.org
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
References: <467F8FCF.4080009@gmx.net> <4683BC76.8070805@ums.usu.ru> <20070628161720.298550@gmx.net> <46843B9B.2080700@tmr.com> <20070629083021.58530@gmx.net>
In-Reply-To: <20070629083021.58530@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:

> Well, I think all that LFS seems to want is links that are
> stable "for a while" (since I don't suppose that they want
> to use really old tarballs in any case). So, for 
> the benefit of LFS, I'll just be less aggressive about
> moving tarballs into "Old" (I'll leave them sitting in http://www.kernel.org/pub/linux/docs/manpages/
> for a few months at least.)

If this helps, here is the version information.

Stable LFS (version 6.2, released on August 3, 2006) tells users to download 
man-pages 2.34 (two releases old at that time). LFS-6.3 is expected to be 
released in two months or so, thus a one-year period before moving tarballs 
to "Old" should be enough even for stable LFS books (and if we agree on 
that, I'll close http://wiki.linuxfromscratch.org/lfs/ticket/2037 as invalid).

Thanks for cooperation.

-- 
Alexander E. Patrakov
