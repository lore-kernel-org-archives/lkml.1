Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZF2COI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZF2COI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZF2CN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:13:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50189 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZF2CN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:13:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19016.9058.719104.420122@cargo.ozlabs.ibm.com>
Date: Mon, 29 Jun 2009 12:13:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: performance counter ~0.4% error finding retired instruction
	count
In-Reply-To: <19016.8971.391008.394778@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
	<20090624151010.GA12799@elte.hu>
	<Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
	<Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy>
	<20090627060432.GB16200@elte.hu>
	<19013.49344.860564.948905@cargo.ozlabs.ibm.com>
	<20090627172854.GE21595@elte.hu>
	<19016.8971.391008.394778@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras writes:

> I can think of three ways to eliminate the PLT resolver overhead on
> execvp:

s/three/four/, obviously - I thought of the 4th while I was writing
the mail.

Paul.
