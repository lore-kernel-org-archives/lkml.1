Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZCRW2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZCRW2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZCRW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:28:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:1558 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbZCRW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:28:28 -0400
Date: Thu, 19 Mar 2009 09:27:57 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       takedakn@nttdata.co.jp
Subject: Re: What's coming in the security subsystem
In-Reply-To: <49C10CA8.3060801@s5r6.in-berlin.de>
Message-ID: <alpine.LRH.2.00.0903190925500.15412@tundra.namei.org>
References: <alpine.LRH.2.00.0903181010030.6028@tundra.namei.org> <49C10CA8.3060801@s5r6.in-berlin.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Stefan Richter wrote:

> James Morris wrote:
> >       IMA: fix ima_delete_rules() definition
> 
> Since the term IMA and the implementation are new and specialist, the
> meaning of this TLA is not widely known.  Hence it would be nice if you
> prefixed IMA changes with "integrity: IMA:" like some of the other
> pending IMA changes.
> 
> > Kentaro Takeda (8):
> >       Add in_execve flag into task_struct.
> >       Memory and pathname management functions.
> >       Common functions for TOMOYO Linux.
> >       File operation restriction part.
> >       Domain transition handler.
> >       LSM adapter functions.
> >       Kconfig and Makefile
> >       MAINTAINERS info
> 
> A "TOMOYO:" prefix would add a nice touch to these titles.

It's too late to change the existing commits, but there definitely should 
have been 'tomoyo:' prefixes in the patch subjects.

-- 
James Morris
<jmorris@namei.org>
