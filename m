Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbYERL1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbYERL1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYERL1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:27:41 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:57238 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753126AbYERL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:27:40 -0400
Date: Sun, 18 May 2008 12:27:28 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: James Cammarata <jimi@sngx.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH updated] net: add ability to clear per-interface network statistics via procfs
Message-ID: <20080518112727.GL28241@solarflare.com>
References: <482DA5B6.1020606@sngx.net> <482DB46A.8020103@cosmosbay.com> <482EF192.4070707@sngx.net> <482F5113.5090703@cosmosbay.com> <482F610D.2080108@sngx.net> <20080518003104.GK28241@solarflare.com> <482FBA09.80201@sngx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482FBA09.80201@sngx.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Cammarata wrote:
> >You need to stop your mail client word-wrapping patches.  It looks like
> >something has converted tabs to spaces, too.
> 
> Hmm, I don't know what might be causing that.  I'm using Thunderbird and 
> disabled wrapping, and things look ok on lkml when I view the archives 
> there.

Sorry, you're right - your messages are marked as format=flowed, which
means they should be word-wrapped when displayed.  This is odd but
doesn't break the patches.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
