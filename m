Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbXHMNwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbXHMNwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762395AbXHMKcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:32:42 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:38459
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763622AbXHMKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:32:40 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Distributed storage.
Date: Mon, 13 Aug 2007 03:32:33 -0700
User-Agent: KMail/1.9.5
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708130315.08382.phillips@phunq.net> <20070813102255.GN23758@kernel.dk>
In-Reply-To: <20070813102255.GN23758@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130332.33737.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 03:22, Jens Axboe wrote:
> I never compared the bio to struct page, I'd obviously agree that
> shrinking struct page was a worthy goal and that it'd be ok to uglify
> some code to do that. The same isn't true for struct bio.

I thought I just said that.

Regards,

Daniel
