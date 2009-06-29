Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZF2X0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZF2X0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZF2X0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:26:06 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:54109 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755228AbZF2X0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:26:05 -0400
Date: Mon, 29 Jun 2009 19:25:52 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, Jesper.Nilsson@axis.com,
       benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Mike Frysinger <vapier@gentoo.org>,
       Tony Luck <tony.luck@intel.com>, Andy Grover <andy.grover@oracle.com>
Subject: Re: [PATCH 05/10] percpu: use DEFINE_PER_CPU_SHARED_ALIGNED()
In-Reply-To: <1245825924-30412-6-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0906291925360.32637@gentwo.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org> <1245825924-30412-6-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

