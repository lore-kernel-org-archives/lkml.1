Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXF1NuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXF1NuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXF1Nt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:49:56 -0400
Received: from relay4.usu.ru ([194.226.235.39]:47394 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbXF1Ntz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:49:55 -0400
Message-ID: <4683BC76.8070805@ums.usu.ru>
Date: Thu, 28 Jun 2007 19:49:42 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
References: <467F8FCF.4080009@gmx.net>
In-Reply-To: <467F8FCF.4080009@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:

> I just released man-pages-2.59 and man-pages-2.60.
> 
> These releases are now available for download at:
> 
>     http://www.kernel.org/pub/linux/docs/manpages

There is one little problem with this: there is no stable URL for a given 
version. This hurts, e.g., automated Linux From Scratch rebuilds (the 
official script grabs the URL from the book, but it becomes invalid too soon).

Could you please, in order to avoid this, do what SAMBA team does: place 
into http://www.kernel.org/pub/linux/docs/manpages/Old not only old 
versions, but also the current version? This way, LFS will be sure that the 
2.60 version is always available as 
http://www.kernel.org/pub/linux/docs/manpages/Old/man-pages-2.60.tar.bz2 
(even if it is in fact the latest version).

Thanks in advance.

-- 
Alexander E. Patrakov
