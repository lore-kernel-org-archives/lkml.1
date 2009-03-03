Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZCCGF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZCCGF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZCCGFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:05:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:50429 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751889AbZCCGFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:05:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1++LWgig6i+kbQMzV6sSYw5NBWSqslmNJtfkfwBqv
	dLf6zkNeDmlY7+
Subject: Re: x86-tip: xine bustage bisection fingers
	commit	97286a2b64725aac2d584ddd1f94871f9991d5a1
From: Mike Galbraith <efault@gmx.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
In-Reply-To: <49AC85C1.7060600@ct.jp.nec.com>
References: <1235984665.6195.12.camel@marge.simson.net>
	 <20090302093319.GB20897@elte.hu>  <49AC85C1.7060600@ct.jp.nec.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 07:04:58 +0100
Message-Id: <1236060298.6060.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 17:20 -0800, Hiroshi Shimamoto wrote:

> I made a patch to fix this issue.
> This patch is against tip/x86/signal.

Yes, this fixed my xine woes.

	-Mike

