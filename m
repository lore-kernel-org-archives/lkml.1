Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXCFVNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXCFVNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXCFVNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:13:21 -0500
Received: from gw.goop.org ([64.81.55.164]:41111 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbXCFVNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:13:20 -0500
Message-ID: <45EDD96D.1030108@goop.org>
Date: Tue, 06 Mar 2007 13:13:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>,
       virtualization <virtualization@lists.osdl.org>,
       Roland McGrath <roland@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: Xen & VMI?
References: <45ED82D9.6050204@codemonkey.ws> <8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com> <20070306203712.GC21736@elte.hu> <45EDD6F1.7080100@goop.org> <20070306211105.GD26348@elte.hu>
In-Reply-To: <20070306211105.GD26348@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> so trying to argue as if there was no ABI imposed on Linux by hiding the 
> Xen ABI behind paravirt_ops, and whistling into the air as if nothing 
> happened is misguided at best.

How is the situation even slightly different with a unified hypervisor ABI?

    J

