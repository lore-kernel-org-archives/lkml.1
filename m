Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYEaEpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYEaEpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYEaEpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:45:10 -0400
Received: from main.gmane.org ([80.91.229.2]:57056 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbYEaEpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:45:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Anthony Green <green@spindazzle.org>
Subject: Re: =?utf-8?b?dHJhY2VfbWFyaw==?= ugliness
Date: Sat, 31 May 2008 01:06:00 +0000 (UTC)
Message-ID: <loom.20080531T005930-231@post.gmane.org>
References: <Pine.LNX.4.58.0805220949560.14724@gandalf.stny.rr.com>  <20080522171602.GB22806@Krystal>  <1211714403.6463.294.camel@lappy.programming.kicks-ass.net>  <20080527133651.GA9428@Krystal> <1211987977.12349.91.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 74.15.54.82 (Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz <at> infradead.org> writes:
> The sad truth is that gcc is taking out most of the function forwarding
> helpers in favour of libffi, and libffi is far from self hosting and
> quite horrible to look at - so importing that into the kernel isn't
> going to work either :-/

Peter,

Either you're using the term "self hosting" in some way I don't understand, or
you meant to say that it doesn't build outside of the GCC tree.  Actually, it
does, if you use the upstream version here: http://sourceware.org/libffi.

Anthony Green


