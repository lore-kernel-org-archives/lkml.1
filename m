Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYHHQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYHHQVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYHHQVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:21:39 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:42635 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYHHQVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:21:39 -0400
Date: Fri, 8 Aug 2008 18:27:04 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: <JosephChan@via.com.tw>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, geert@linux-m68k.org
Subject: Re: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer
 Device Driver
Message-Id: <20080808182704.28bd9fb3.krzysztof.h1@poczta.fm>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698C@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698C@exchtp03.taipei.via.com.tw>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 5ae2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 18:09:21 +0800
<JosephChan@via.com.tw> wrote:

> Hi all,
> 
> Here comes the 13 updated patchs for VIA Frame Buffer Device Driver.
> This driver could be used on VIA UniChrome (Pro) and Chrome9 family chips.
> All the patches are based on linux kernel 2.6.27-rc2 and they're modified by adopting community's feedback.
> I would like to thank all who provided their suggestions for VIAFB by mail.
> Any question, please contact me. Thanks.
> 

Please resend the 3rd patch as it is damaged (missing 3 lines of each file).

I am for merging these patches as they are sent now. It allows sending 
fixes to them as incremental patches.

This set builds at least for my configuration (Pentium3 SMP). 
Unfortunately, I do not have hardware to test. I though about
buying one of these sexy VIA ITX boards but it is outside my
budget now. Anyway, I have too many computers according
to my spouse.

Kind regards,
Krzysztof


----------------------------------------------------------------------
Tylko dla detektywow! Konkurs na Smaker.pl
Kliknij >>> http://link.interia.pl/f1eb1

