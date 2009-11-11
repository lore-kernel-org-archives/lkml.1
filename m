Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZKKOMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZKKOMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZKKOL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:11:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:34636 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZKKOLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:11:55 -0500
Date: Wed, 11 Nov 2009 15:11:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Markku Savela <msa@moth.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
In-Reply-To: <874op2wcna.fsf@burp.tkv.asdf.org>
Message-ID: <alpine.LRH.2.00.0911111511250.31913@twin.jikos.cz>
References: <dDwJH-3PE-7@gated-at.bofh.it> <874op2wcna.fsf@burp.tkv.asdf.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Markku Savela wrote:

> I'm wondering why on architectures that actually have EXECUTE
> permission memory management, the user space is mapped into kernel
> with EXECUTE enabled!!!??

x86, to give one random example?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

