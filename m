Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYKTXxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYKTXxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYKTXx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:53:26 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:32884 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYKTXx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:53:26 -0500
Date: Thu, 20 Nov 2008 17:52:49 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <Pine.LNX.4.64.0811191341570.23502@quilx.com>
Message-ID: <Pine.LNX.4.64.0811201727070.9089@quilx.com>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera>
 <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmmm... Well we are almost there.

2.6.22:

Throughput 2526.15 MB/sec 8 procs

2.6.28-rc5:

Throughput 2486.2 MB/sec 8 procs

8p Dell 1950 and the number of processors specified on the tbench command
line.
