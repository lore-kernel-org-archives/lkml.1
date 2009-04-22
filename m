Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZDVHYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZDVHYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZDVHYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:24:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44065 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZDVHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:24:20 -0400
Date: Wed, 22 Apr 2009 09:27:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, mce: Add options for corrected errors (no_cmci/dont_log_ce/ignore_ce)
Message-ID: <20090422072751.GD14687@one.firstfloor.org>
References: <49EBCDB0.7000505@jp.fujitsu.com> <49EBCF87.4090608@jp.fujitsu.com> <87myabpyrn.fsf@basil.nowhere.org> <49EC3AC0.8070109@jp.fujitsu.com> <49EE8E10.9060400@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE8E10.9060400@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 12:25:04PM +0900, Hidetoshi Seto wrote:
> Here is the updated one.

Patch is ok for me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
