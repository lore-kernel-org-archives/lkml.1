Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZLTPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZLTPB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 10:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZLTPB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 10:01:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZLTPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 10:01:25 -0500
Subject: Re: CPU offline/online related hang with latest git
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20091220145715.GZ4489@kernel.dk>
References: <4B2DF699.3090107@in.ibm.com> <1261315887.4314.8.camel@laptop>
	 <20091220145151.GY4489@kernel.dk> <1261320896.4314.10.camel@laptop>
	 <20091220145715.GZ4489@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 16:00:22 +0100
Message-ID: <1261321222.4314.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 15:57 +0100, Jens Axboe wrote:

> Exactly, hence the connection. Shall I bisect, or do you already know
> what the problem is?

I have a definite suspect alright, let me prod at this a bit more.

