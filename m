Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250Ab0A0WWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0A0WWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211Ab0A0WWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:22:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51043 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756087Ab0A0WWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:22:37 -0500
Date: Wed, 27 Jan 2010 22:24:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <JBottomley@Novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc5
Message-ID: <20100127222404.6dfdd0a7@lxorguk.ukuu.org.uk>
In-Reply-To: <1264614691.3075.19.camel@mulgrave.site>
References: <1264614691.3075.19.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Penchala Narasimha Reddy Chilakala, ERS-HCLTech (1):
>       aacraid: fix File System going into read-only mode

If aacraid is actually getting patches then see
also http://bugzilla.kernel.org/show_bug.cgi?id=11120 which I found
bugzilla tidyying.

Contains a patch and test confirmations


