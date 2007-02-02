Return-Path: <linux-kernel-owner+w=401wt.eu-S1422993AbXBBMJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422993AbXBBMJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423036AbXBBMJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:09:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:45259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422993AbXBBMJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:09:51 -0500
To: Markus Wenke <M.Wenke@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Try to fill route cache
References: <45C08EA6.9070504@web.de>
From: Andi Kleen <ak@suse.de>
Date: 02 Feb 2007 14:10:25 +0100
In-Reply-To: <45C08EA6.9070504@web.de>
Message-ID: <p73irekogce.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Wenke <M.Wenke@web.de> writes:
> 
> Where is the problem ?

pktgen doesn't use the routing cache.

-Andi
