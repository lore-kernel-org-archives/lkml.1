Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZEVPPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZEVPPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbZEVPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:15:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbZEVPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:15:12 -0400
Subject: Re: [PATCH] kernel:lockdep:print the shortest dependency chain if 
 finding a circle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ming Lei <tom.leiming@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <d82e647a0905220812q19aff43fw23cb9dc0ce1b5a76@mail.gmail.com>
References: <1242918732-4988-1-git-send-email-tom.leiming@gmail.com>
	 <d82e647a0905220812q19aff43fw23cb9dc0ce1b5a76@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 17:15:05 +0200
Message-Id: <1243005305.6582.672.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 23:12 +0800, Ming Lei wrote:
> Any objections or suggestions?

Non yet, yesterday was a holiday here in Europe and I haven't had time
to go over the patch in detail yet.

I do appreciate it though and at a first glance it does look good.



