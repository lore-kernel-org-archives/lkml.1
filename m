Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXDKKU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXDKKU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXDKKU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:20:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXDKKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:20:58 -0400
Date: Wed, 11 Apr 2007 12:20:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       WU Fengguang <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH] Improve heuristic detecting sequential reads
Message-ID: <20070411102054.GA15253@one.firstfloor.org>
References: <20070410155411.GF13445@duck.suse.cz> <p73y7kzj0ss.fsf@bingen.suse.de> <20070410164540.6d10ddd7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410164540.6d10ddd7.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> adaptive readahead?  Has been in -mm for a year.  Problem is, it is
> _so_ complete that I just don't know how to merge it.  It's huge, and
> only Wu understands it. So it's really rather stuck.

No benchmark numbers for/against it at all?

-Andi
> 
