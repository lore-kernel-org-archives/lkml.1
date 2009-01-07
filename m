Return-Path: <linux-kernel-owner+w=401wt.eu-S1763273AbZAGX0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763273AbZAGX0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZAGX0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:26:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45531 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbZAGX0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:26:09 -0500
Date: Wed, 7 Jan 2009 21:25:16 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, airlied <airlied@linux.ie>,
       Eric Anholt <eric@anholt.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: replace last usages of __FUNCTION__ in kernel
Message-ID: <20090107212516.499f22d9@pedra.chehab.org>
In-Reply-To: <1231368161.5586.30.camel@brick>
References: <1231368161.5586.30.camel@brick>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jan 2009 14:42:41 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>


Cheers,
Mauro
