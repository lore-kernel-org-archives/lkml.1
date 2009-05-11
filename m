Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZEKNJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZEKNJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZEKNJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:09:39 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:25923 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZEKNJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:09:38 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC/PATCH 0/6] lockdep: Maintain read/write states for
 lock_acquires
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
References: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 15:09:35 +0200
Message-Id: <1242047375.11251.271.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 18:09 +0530, Gautham R Shenoy wrote:

> Feedback is very much appreciated.

Awesome work :-)

Didn't spot any obvious (in so far as that that word can apply to this
series) boo-boos.

More in-depth review will follow a bit later.

