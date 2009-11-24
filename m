Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbZKXPkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbZKXPkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZKXPkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:40:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57077 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbZKXPkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:40:02 -0500
Subject: Re: [tip:tracing/core] ring-buffer benchmark: Run
 producer/consumer threads at nice +19
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20091124152245.GB21821@elte.hu>
References: <new-submission>
	 <tip-98e4833ba3c314c99dc364012fba6ac894230ad0@git.kernel.org>
	 <1259072207.22249.1066.camel@gandalf.stny.rr.com>
	 <20091124143923.GA17934@elte.hu>
	 <1259074860.22249.1071.camel@gandalf.stny.rr.com>
	 <20091124152245.GB21821@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 10:40:07 -0500
Message-Id: <1259077207.22249.1079.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 16:22 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> We still have the perl overhead in function-tracing kernel builds btw
> :-/

Yes I know. Someone did send me a patch to start the conversion to C,
but it needs to be audited quite thoroughly.

-- Steve


