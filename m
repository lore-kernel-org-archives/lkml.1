Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYFDVeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYFDVeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbYFDVdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:33:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYFDVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:33:53 -0400
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 4 -
	firmware/keyspan/mpr.fw.gen.S
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20080604182011.GD4189@cs181133002.pp.htv.fi>
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au>
	 <48468091.5000102@linux.vnet.ibm.com>
	 <1212580245.32207.51.camel@pmac.infradead.org>
	 <54a3f4cc48b03f9fe63be0bcd7c2ab20@kernel.crashing.org>
	 <1212601930.32207.134.camel@pmac.infradead.org>
	 <20080604182011.GD4189@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 22:33:41 +0100
Message-Id: <1212615221.25049.22.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 21:20 +0300, Adrian Bunk wrote:
> 
> Can you write make < 3.81 instead?
> 
> We do know the version and this will make it easier in a few years to 
> determine when the workaround will no longer be required.

Done.

-- 
dwmw2

