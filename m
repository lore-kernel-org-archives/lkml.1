Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZFBP27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZFBP27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZFBP2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:28:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52336 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZFBP2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:28:51 -0400
Date: Tue, 2 Jun 2009 11:28:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH/RFC 4/4] add dynamic ftrace support
In-Reply-To: <20090602110512.792641005@de.ibm.com>
Message-ID: <alpine.DEB.2.00.0906021128330.14994@gandalf.stny.rr.com>
References: <20090602105311.591592481@de.ibm.com> <20090602110512.792641005@de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Jun 2009, Heiko Carstens wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Dynamic ftrace support for s390.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Looks good.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
