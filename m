Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbYFDL56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbYFDL56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYFDL5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:57:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55695 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYFDL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:57:49 -0400
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 4 -
	firmware/keyspan/mpr.fw.gen.S
From: David Woodhouse <dwmw2@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <1212580245.32207.51.camel@pmac.infradead.org>
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au>
	 <48468091.5000102@linux.vnet.ibm.com>
	 <1212580245.32207.51.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 12:57:42 +0100
Message-Id: <1212580662.32207.54.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 12:50 +0100, David Woodhouse wrote:
> Hm, what version of make? Does .SECONDEXPANSION: not work everywhere?

What does this Makefile do for you...

FOO=foo
.SECONDEXPANSION:
bar: $$(FOO)

-- 
dwmw2

