Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbXF1Kch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbXF1Kch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXF1Kca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:32:30 -0400
Received: from odin.mimer.no ([213.184.200.1]:42609 "EHLO odin.mimer.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbXF1Kc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:32:29 -0400
From: Harald Arnesen <harald@skogtun.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, mrmacman_g4@mac.com,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org, david@lang.hm
Subject: Re: Userspace compiler support of "long long"
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	<Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	<467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	<1182483527.10524.31.camel@shinybook.infradead.org>
	<20070622150038.GN23017@stusta.de>
	<E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
	<20070627154046.GN1094@stusta.de>
	<468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
	<20070627173240.GR1094@stusta.de>
Date: Thu, 28 Jun 2007 12:26:06 +0200
In-Reply-To: <20070627173240.GR1094@stusta.de> (Adrian Bunk's message of "Wed,
	27 Jun 2007 19:32:40 +0200")
Message-ID: <87ejjwgytd.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> Is there any userspace Linux compiler that does not support "long long"?
> If yes, is there any other way to tell that something is a
> 64bit int on 32bit architectures?

TenDRA C:

"test.c", line 6: Error:
  [ISO 6.5.2]: Illegal type specifier, 'long long', assuming 'long'.

-- 
Hilsen Harald.

