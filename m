Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZKLUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZKLUAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZKLUAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:00:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35863 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbZKLUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:00:30 -0500
Date: Thu, 12 Nov 2009 20:02:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eran Liberty <liberty@extricom.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: avoid Break bouncing
Message-ID: <20091112200212.0f2d1e40@lxorguk.ukuu.org.uk>
In-Reply-To: <20091112162120.45b33ecf@pedra.chehab.org>
References: <20091112140504.6daf3824@pedra.chehab.org>
	<20091112175649.145cbf18@lxorguk.ukuu.org.uk>
	<20091112162120.45b33ecf@pedra.chehab.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll do a deeper analysis and come back with a patch only if I discover
> something new about this issue.

I'll forward you the end of the previous discussion
