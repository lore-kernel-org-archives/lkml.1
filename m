Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653Ab0A2Stb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0A2Stb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766Ab0A2Sta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:49:30 -0500
Received: from mail.perches.com ([173.55.12.10]:1600 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab0A2St3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:49:29 -0500
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
From: Joe Perches <joe@perches.com>
To: tytso@mit.edu, Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20100129051953.GM28459@thunk.org>
References: <1264597747.3607.29.camel@wall-e>
	 <87hbq6dy2k.fsf@basil.nowhere.org> <17r837-m29.ln1@chipmunk.wormnet.eu>
	 <20100129051953.GM28459@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 10:49:28 -0800
Message-ID: <1264790968.25140.25.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 00:19 -0500, tytso@mit.edu wrote:
> Linus has already agreed that the 80 character limit is stupid.  Let's
> just nuke this check from checkpatch.pl and move on.

Andy, can you update checkpatch please?

I proposed this: http://lkml.org/lkml/2009/12/18/3

If you're too busy, I can collect the several
additional patches that have been suggested and
push them to you or to Andrew Morton.

