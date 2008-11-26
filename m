Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYKZQtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYKZQtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYKZQt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:49:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYKZQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:49:27 -0500
Date: Wed, 26 Nov 2008 11:49:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5] ftrace: add cpu annotation for function graph
 tracer
In-Reply-To: <20081125213909.d4eb3f09.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811261149120.26743@gandalf.stny.rr.com>
References: <20081126051622.134970943@goodmis.org> <20081126051710.339437727@goodmis.org> <20081125213909.d4eb3f09.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Nov 2008, Andrew Morton wrote:

> On Wed, 26 Nov 2008 00:16:27 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This patch adds the annotation of 'CPU[###]' where ### is a three digit
> > number
> 
> Is this a plot to get yourself sent a 1024-way test box?


Have an extra one?

;)

-- Steve

