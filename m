Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYL3Huq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYL3Huq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYL3Hug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:50:36 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34068 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYL3Hug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:50:36 -0500
Subject: Re: [PATCH 2/2] kmemtrace: Use tracepoints instead of markers.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro>
References: <cover.1230622068.git.eduard.munteanu@linux360.ro>
	 <86493e5e7b0a47e8acf0350a87ab3f22633a5789.1230622069.git.eduard.munteanu@linux360.ro>
	 <51a70358bfd74d84c844260d9b5b3ad6ac189d7d.1230622069.git.eduard.munteanu@linux360.ro>
Date: Tue, 30 Dec 2008 09:50:34 +0200
Message-Id: <1230623434.6091.11.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-30 at 09:41 +0200, Eduard - Gabriel Munteanu wrote:
> kmemtrace now uses tracepoints instead of markers. We no longer need to
> use format specifiers. Also dropped kmemtrace_mark_alloc_node(), since
> it's easy to pass -1 as the NUMA node without providing a needless and
> long-named variant of the same function.
> 
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>


