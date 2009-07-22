Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZGVNDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZGVNDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZGVNDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:03:49 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:9892 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbZGVNDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:03:49 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:core/locking 1/3] lockdep:reintroduce generation count to
 make BFS faster
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: tom.leiming@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
In-Reply-To: <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 15:04:58 +0200
Message-Id: <1248267898.27058.1407.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 20:58 +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> We still can apply DaveM's generation count optimization to
> BFS, so reintroduce it.

Please elaborate, changelogs are important.

You fail to explain why it still applies and what the gains are.

(I can guess, but you explaining makes sure we're on the same page)

