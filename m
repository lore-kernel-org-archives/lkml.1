Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZJNJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZJNJnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZJNJnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbZJNJnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:43:16 -0400
Date: Wed, 14 Oct 2009 06:41:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, bluesmoke-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] edac: Create an unique instance for each kobj
Message-ID: <20091014064138.250777cd@pedra.chehab.org>
In-Reply-To: <20091013200117.895885a6.akpm@linux-foundation.org>
References: <20090924192821.7fcffc80@pedra.chehab.org>
	<20091004164354.5ff55ea1@pedra.chehab.org>
	<20091013200117.895885a6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Em Tue, 13 Oct 2009 20:01:17 -0700
Andrew Morton <akpm@linux-foundation.org> escreveu:

> On Sun, 4 Oct 2009 16:43:54 -0300 Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > Current code only works when there's just one memory
> > controller, since we need one kobj for each instance.
> 
> I don't know which kernel you're patching here, but it doesn't look
> anything like mine...

It is on i7core_edac git tree. This tree were added to linux-next. You'll be
able to see it starting from today's linux-next.

Cheers,
Mauro
