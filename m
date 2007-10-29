Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbXJ2PAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbXJ2PAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXJ2PAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:00:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52961 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbXJ2PAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:00:01 -0400
Date: Mon, 29 Oct 2007 07:59:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, "William L. Irwin" <wli@holomorphy.com>
Subject: Re: [patch 05/10] Move profiling to instrumentation
Message-ID: <20071029075950.3263767f@laptopd505.fenrus.org>
In-Reply-To: <20071029142940.219544075@polymtl.ca>
References: <20071029142646.699058449@polymtl.ca>
	<20071029142940.219544075@polymtl.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 10:26:51 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Move kernel/profile.c to instrumentation/.


I have one question... can this be done via a git move command so that
history is properly maintained?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
