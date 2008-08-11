Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYHKOWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYHKOWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYHKOWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:22:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35049 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYHKOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:22:38 -0400
Subject: Re: [PATCH 4/5] kmemtrace: SLUB hooks.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <48A04AEE.8090606@linux-foundation.org>
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>
	 <48A046F5.2000505@linux-foundation.org>
	 <1218463774.7813.291.camel@penberg-laptop>
	 <48A048FD.30909@linux-foundation.org>
	 <1218464177.7813.293.camel@penberg-laptop>
	 <48A04AEE.8090606@linux-foundation.org>
Date: Mon, 11 Aug 2008 17:22:37 +0300
Message-Id: <1218464557.7813.295.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-11 at 09:21 -0500, Christoph Lameter wrote:
> Pekka Enberg wrote:
> 
> > The function call is supposed to go away when we convert kmemtrace to
> > use Mathieu's markers but I suppose even then we have a problem with
> > inlining?
> 
> The function calls are overwritten with NOPs? Or how does that work?

I have no idea. Mathieu, Eduard?

