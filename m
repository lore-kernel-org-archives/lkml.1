Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZJIIDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZJIIDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbZJIIDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:03:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZJIIDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:03:11 -0400
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for 
 CPU"
From: Peter Zijlstra <peterz@infradead.org>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Mike Galbraith <efault@gmx.de>, Frans Pop <elendil@planet.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-wireless@vger.kernel.org
In-Reply-To: <2d0a357f0910090055v7a454ca5rb895fecbb9747ecd@mail.gmail.com>
References: <200910051500.55875.elendil@planet.nl>
	 <200910081655.37485.elendil@planet.nl>
	 <1255026217.6643.12.camel@marge.simson.net>
	 <200910082259.35204.elendil@planet.nl>
	 <1255070103.7639.30.camel@marge.simson.net>
	 <2d0a357f0910090055v7a454ca5rb895fecbb9747ecd@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Oct 2009 10:06:28 +0200
Message-Id: <1255075588.26976.359.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 09:55 +0200, Sedat Dilek wrote:
> 
> will you (re)send this patch as a new one with correct subject line to LKML?
> Otherwise, it might disapper in this long thread.

No need, I've got it.
