Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbXISQUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbXISQUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761707AbXISQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:20:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32973 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761890AbXISQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:20:26 -0400
Date: Wed, 19 Sep 2007 17:20:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Wilder <dwilder@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
Message-ID: <20070919162018.GA16237@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F12ED7.3060605@us.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 07:14:47AM -0700, David Wilder wrote:
> I agree with you; however, this is in the example code in the 
> Documentation directory,  It is not part of the trace code.  The example 
> was just meant to be a demonstration of how the interface works.

So we tell people to write bad code?  Wonderful..

And while we're at it can we please stop the dumb idea to put example
code into Documentation?  If example code doesn't get build during a
make oldconfig it will bitrot real fast and not be useful at all.
