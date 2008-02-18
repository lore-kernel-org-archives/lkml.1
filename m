Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYBRRg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYBRRg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbYBRRgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:36:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYBRRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:36:20 -0500
Date: Mon, 18 Feb 2008 14:36:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL - resend] V4L/DVB fixes - first request on Feb, 12
Message-ID: <20080218143602.338063e8@gaivota>
In-Reply-To: <20080218124351.4da5d6d2@gaivota>
References: <20080218124351.4da5d6d2@gaivota>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 12:43:51 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> 	   - bug #9832: tuner-xc2028 depends on FW_LOADER;

In time: the but is bug is the second part of #9965 (and not 9832):
	ERROR: "release_firmware" [drivers/media/video/tuner-xc2028.ko] undefined! 
	ERROR: "request_firmware" [drivers/media/video/tuner-xc2028.ko] undefined!


Cheers,
Mauro
