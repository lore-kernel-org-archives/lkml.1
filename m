Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbZF3XUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbZF3XUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760633AbZF3XTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:19:18 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59225 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760631AbZF3XTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:19:16 -0400
Date: Tue, 30 Jun 2009 19:18:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
In-Reply-To: <20090630230743.GA17968@elte.hu>
Message-ID: <alpine.DEB.1.10.0906301917170.15482@gentwo.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu>
 <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <20090630223138.GH1241@elte.hu> <alpine.DEB.1.10.0906301847260.19482@gentwo.org> <20090630230743.GA17968@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Ingo Molnar wrote:

> Say it says "256 CPUs".

Ok then you found a bug in the virtualization software ;-).
