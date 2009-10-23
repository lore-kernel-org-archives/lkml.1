Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZJWV7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZJWV7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZJWV7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:59:38 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39177 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZJWV7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:59:37 -0400
MIME-Version: 1.0
In-Reply-To: <193b0f820910231456o24bf95b6mf3e72f1b27870af5@mail.gmail.com>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> 
	<20091023210231.GC8356@elte.hu> <193b0f820910231456o24bf95b6mf3e72f1b27870af5@mail.gmail.com>
From: Marti Raudsepp <marti@juffo.org>
Date: Sat, 24 Oct 2009 00:59:21 +0300
Message-ID: <54b33ccd0910231459j5cb355c4n13859c527e1645ba@mail.gmail.com>
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and 
	autodetect
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 24, 2009 at 12:56 AM, Lucas De Marchi
<lucas.de.marchi@gmail.com> wrote:
> I think it's Arch's fault to continue using an unmaintained library
> when there's an easy replacement, but if the "fix" is easy, why not?

As far as I can tell, libelf is still maintained; the latest release
is from July 2009.

Regards,
Marti
