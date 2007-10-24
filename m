Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbXJXTBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbXJXTBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXJXTBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:01:13 -0400
Received: from gw.goop.org ([64.81.55.164]:58070 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbXJXTBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:01:12 -0400
Message-ID: <471F965B.6090200@goop.org>
Date: Wed, 24 Oct 2007 12:00:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_XEN dependencies
References: <471DE2F8.76E4.0078.0@novell.com> <471E38D6.5050202@xensource.com> <471F1EEE.76E4.0078.0@novell.com>
In-Reply-To: <471F1EEE.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> The specific goal is to be able to enable the XEN option in our native kernel,
> which gets configured with M586. So we could live with XEN depending on
> X86_CMPXCHG, but would definitely need the dependency on X86_TSC
> dropped. Nevertheless I'd favor even X86_CMPXCHG dropped unless that
> causes unresolvable (or difficult to resolve) problems.

Seems reasonable.  Do you have a patch?

    J

