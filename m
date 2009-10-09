Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbZJIVzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbZJIVzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934518AbZJIVzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:55:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934502AbZJIVzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:55:19 -0400
Date: Fri, 9 Oct 2009 23:54:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Reza Salehi <rezsalehi@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: Question about "scheduling while atomic"
In-Reply-To: <840534.40534.qm@web53206.mail.re2.yahoo.com>
Message-ID: <alpine.LRH.2.00.0910092353560.12171@twin.jikos.cz>
References: <840534.40534.qm@web53206.mail.re2.yahoo.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Reza Salehi wrote:

> I am wonder where I can post my general questions for help about kernel 
> oopps ?

Depends whether the oops happens with vanilla kernel or with some module 
of yours.

In the former case, lkml is the proper place. In the latter case, post 
full source code to kernel newbies malinglist.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

