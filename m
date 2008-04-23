Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYDWWYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYDWWYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYDWWY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:24:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37668 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbYDWWY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:24:26 -0400
Date: Wed, 23 Apr 2008 17:24:24 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] disable softlockup detection at boottime
Message-ID: <20080423222424.GA13573@sgi.com>
References: <20080423201613.GA8546@sgi.com> <20080423145517.c786015b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423145517.c786015b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 02:55:17PM -0700, Randy Dunlap wrote:
> (b) entry in Documentation/kernel-parameters.txt

Oops, my bad, I missed the other 'nosoftlockup'.
