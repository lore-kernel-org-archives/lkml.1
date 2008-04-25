Return-Path: <linux-kernel-owner+w=401wt.eu-S1760490AbYDYI5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490AbYDYI5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbYDYI5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:57:39 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:4203 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757874AbYDYI5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:57:38 -0400
Date: Fri, 25 Apr 2008 17:56:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 10/11] sh: convert to generic helpers for IPI function calls
Message-ID: <20080425085637.GA30569@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, npiggin@suse.de,
	torvalds@linux-foundation.org, peterz@infradead.org,
	sam@ravnborg.org
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-11-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208890227-24808-11-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:50:26PM +0200, Jens Axboe wrote:
> This converts sh to use the new helpers for smp_call_function() and
> friends, and adds support for smp_call_function_single(). Not tested,
> but it compiles.
> 
> Cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
