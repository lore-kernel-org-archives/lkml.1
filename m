Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYDBTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYDBTfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbYDBTfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:35:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbYDBTfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:35:07 -0400
Date: Wed, 2 Apr 2008 16:34:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Morton <akpm@google.com>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Message-ID: <20080402163418.5b250e04@gaivota>
In-Reply-To: <200804021914.13378.bonganilinux@mweb.co.za>
References: <20080330162006.GA6048@joi>
	<20080401171051.724a9f75@gaivota>
	<200804021914.13378.bonganilinux@mweb.co.za>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I confirm that those patches fixed the bttv-driver for me, it was the 
> misapplied patch that caused the Oops. Please push to Linus and I'll ask 
> Rafael to close the bug as soon as it gets to mainline.

Linus already pulled the patches to mainstream, so, the bugs can be closed.

> Thanx for all your work Mauro and the V4L developers.

Thank you for your time reporting and testing the fixes.

Cheers,
Mauro
