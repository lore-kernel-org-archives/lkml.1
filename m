Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZFYGuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZFYGuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZFYGty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:49:54 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:56702 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZFYGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:49:54 -0400
X-SourceIP: 213.93.53.227
Subject: Re: performance counter 20% error finding retired instruction count
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906242200000.12718@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
	 <20090624151010.GA12799@elte.hu>
	 <Pine.LNX.4.64.0906242200000.12718@pianoman.cluster.toy>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 08:50:00 +0200
Message-Id: <1245912600.31755.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 22:12 -0400, Vince Weaver wrote:
> 
> It's also nice to be able to skip the loader overhead, as the loader can 
> change from system to system and makes it hard to compare counters across 
> various machines.  Though it sounds like the perf utility isn't going to 
> be supporting this anytime soon.

Feel free to contribute such if you think its important.

