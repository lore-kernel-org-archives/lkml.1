Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbXCEP7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbXCEP7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933570AbXCEP7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:59:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXCEP7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:59:19 -0500
Date: Mon, 5 Mar 2007 10:58:45 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH 1/2] x86_64: add reporting of SVM flags to /proc/cpuinfo
Message-ID: <20070305155845.GA15991@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	Joerg Roedel <joerg.roedel@amd.com>, discuss@x86-64.org,
	linux-kernel@vger.kernel.org
References: <20070305143601.GF30318@amd.com> <20070305143911.GG30318@amd.com> <200703051625.31449.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703051625.31449.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 04:25:31PM +0100, Andi Kleen wrote:
 > On Monday 05 March 2007 15:39, Joerg Roedel wrote:
 > > From: Joerg Roedel <joerg.roedel@amd.com>
 > > 
 > > This patch adds the advanced SVM reporting to /proc/cpuinfo on the x86_64
 > > architecture.
 > 
 > Adding more fields to /proc/cpuinfo is always somewhat risky because
 > there are lots of badly written parsers for it.
 > 
 > I considered adding the SVM fields myself, but decided against it because
 > it didn't seem generally useful enough.

Agreed.  I'm more than happy to take patches to x86info however :)

		Dave

-- 
http://www.codemonkey.org.uk
