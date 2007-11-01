Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbXKAO4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbXKAO4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXKAO43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:56:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41224 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbXKAO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:56:29 -0400
Subject: Re: [patch] PID namespace design bug, workaround
From: Peter Zijlstra <peterz@infradead.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <4729E7E4.8070208@openvz.org>
References: <20071101144307.GA29566@elte.hu>  <4729E7E4.8070208@openvz.org>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 15:56:17 +0100
Message-Id: <1193928977.27652.289.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 17:51 +0300, Pavel Emelyanov wrote:

>  So can we, please, 
> keep things as they are for now - the appropriate fix will be ready 
> soon.

Just for the curious, could you outline on how you intend to fix this?

