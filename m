Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbZFRG3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbZFRG3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbZFRG3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:29:24 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37560 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbZFRG3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:29:23 -0400
Date: Thu, 18 Jun 2009 15:28:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux@arm.linux.org.uk,
       linux-m68k@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 13/14] Pramfs: Write Protection
Message-ID: <20090618062833.GB2258@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux@arm.linux.org.uk, linux-m68k@lists.linux-m68k.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Linux Embedded <linux-embedded@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Daniel Walker <dwalker@soe.ucsc.edu>
References: <4A392098.9060205@gmail.com> <20090618025736.GB26531@linux-sh.org> <2ea1731b0906172324g4654966eq22cf0bdbd3eafabf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ea1731b0906172324g4654966eq22cf0bdbd3eafabf@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 08:24:35AM +0200, Marco Stornelli wrote:
> 2009/6/18 Paul Mundt <lethal@linux-sh.org>:
> > H8300 is a nommu platform, so it has no TLB to flush. Yoshinori Sato is
> > the maintainer. Consult the MAINTAINERS file, that's what it is there for.
> 
> I know the MAINTAINERS file but for h8300 there isn't an exactly
> indication (/arch/h8300 as for the other archs).
> 
The file patterns are a new thing, I guess not all of the platforms were
updated. In any event:

UCLINUX FOR RENESAS H8/300 (H8300)
P:      Yoshinori Sato
M:      ysato@users.sourceforge.jp
W:      http://uclinux-h8.sourceforge.jp/
S:      Supported

Which is basically the first thing you find when looking for H8.
