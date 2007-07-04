Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbXGDRw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbXGDRw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbXGDRwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:52:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbXGDRwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:52:20 -0400
Date: Wed, 4 Jul 2007 13:51:42 -0400
From: Dave Jones <davej@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [PATCH] x86: make SMP locks handling interact properly with
	CONFIG_DEBUG_RODATA (2nd try)
Message-ID: <20070704175142.GA3795@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Jan Beulich <jbeulich@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	linux-kernel@vger.kernel.org, patches@x86-64.org
References: <468B5B54.76E4.0078.0@novell.com> <468BBFB3.9080303@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468BBFB3.9080303@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 08:41:39AM -0700, Jeremy Fitzhardinge wrote:
 
 > I'd already posted a patch to remove smp alternatives.  I thought it had 
 > been merged already, but I guess it's in Andi's queue.

What was the rationale behind that?  Given many distros have now
moved to shipping just an SMP kernel, this seems like a step backwards?

	Dave

-- 
http://www.codemonkey.org.uk
