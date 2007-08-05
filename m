Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbXHEUqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbXHEUqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbXHEUqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:46:15 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44021 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757565AbXHEUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:46:14 -0400
X-Sasl-enc: pCVQNloDgD8+t8G57Wng1+2u/2Ufle/fC1SBIDtFvb20 1186346773
Date: Sun, 5 Aug 2007 17:46:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Hugh Dickins <hugh@veritas.com>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Denis Sadykov <denis.m.sadykov@intel.com>, dth <dth@dth.net>
Subject: Re: [1/3] 2.6.23-rc2: known regressions
Message-ID: <20070805204609.GC16723@khazad-dum.debian.net>
References: <46B5FA29.2070509@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B5FA29.2070509@googlemail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Aug 2007, Michal Piotrowski wrote:
> Subject         : T60 ACPI issues/THINKPAD_ACPI_INPUT_ENABLED seems regressive
> References      : http://lkml.org/lkml/2007/8/1/198
>                   http://lkml.org/lkml/2007/8/1/176
> Last known good : ?
	2.6.22
> Submitter       : Michael S. Tsirkin <mst@dev.mellanox.co.il>
>                   Hugh Dickins <hugh@veritas.com>
> Caused-By       : ?
	1a343760b516ca5466d201bec32b1794858b18a5
> Handled-By      : Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Status          : problem is being debugged
	Patch available, and sent upstream for merge
	http://thread.gmane.org/gmane.linux.acpi.devel/24646

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
