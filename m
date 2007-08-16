Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbXHPNSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbXHPNSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757742AbXHPNR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:17:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58869 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbXHPNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:17:57 -0400
Subject: Re: soft lockup detected
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Stark <stark@enterprisedb.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87ps1nx3kl.fsf@oxford.xeocode.com>
References: <87ps1nx3kl.fsf@oxford.xeocode.com>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 15:17:55 +0200
Message-Id: <1187270275.6114.87.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 09:54 +0100, Gregory Stark wrote:

> This is on 2.6.21-1.3194.fc7. I've been trying different kernels but this is
> the first point where I've narrowed down the symptoms to something
> reproducible.

That is a very old kernel, and a vendor kernel at that.
Did any of the different kernels you tried include a recent upstream
one?

