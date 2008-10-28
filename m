Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYJ1SzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYJ1SzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYJ1SzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:55:11 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:24706 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYJ1SzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iTiJZ5C1m84US42uH3dDGxIM7Ma8nwfNZWGeKtHn19LaTjcsStcQ4HixogeQyuFKqb
         K2NWs13NHPZ9+0IA726k/A08kK+bndGwrW3e/dH3Q6hN+o0ydou1acnIWQGR5Y6TztNY
         6BGSdAx2r0hVFmm/ujQkKTqP65yk6bUg27N/Y=
Message-ID: <1f7d355e0810281155t37bc39fdp9f3b65a9dced3b1b@mail.gmail.com>
Date: Tue, 28 Oct 2008 19:55:08 +0100
From: "Raavi M. Mohindar Rao" <raavi.mohindar.rao@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Processor Technology: Cores with Virtual Boundary
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Processor Technology: Cores with Virtual Boundary
======================================

Today's processors are based on multi-core architecture with real
physical boundaries that separates the cores inside the processor or a
chip and this approach can be optimum for executing general or
specific tasks with intelligent schedulers.

My curiosity is, what will happen if we can able to remove those real
physical boundaries that separates the cores? Is it possible to
overcome the ultimate limits on performance or does it all boils down
to single-core architecture, if we can able to realize the above.

In any case, I don't let the desing boiling to single-core but staying
on multi-core with virtual boundaries or no boundaries at all.

If it is possible then that it will be cool thing, like we can
introduce 'ringed' cores with no real boundaries or any other topology
which are best suitable for breaking the limits of performance.

Your comments please.

Further I am not a processor guy and in case if you like to discuss
any intricates of processor design then I may not able to write much
about it. Sorry for that.

Best Regards,
