Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbXFAS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbXFAS3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbXFAS3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:29:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760938AbXFAS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:29:06 -0400
Date: Fri, 1 Jun 2007 14:28:35 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-ID: <20070601182835.GC16529@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net> <20070601181414.GC7968@redhat.com> <20070601112225.80a8be84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601112225.80a8be84.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 11:22:25AM -0700, Andrew Morton wrote:
 > On Fri, 1 Jun 2007 14:14:14 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > On Thu, May 31, 2007 at 07:09:10PM -0700, Andrew Morton wrote:
 > >  > From: Andrew Morton <akpm@linux-foundation.org>
 > >  > 
 > >  > Explain what we use Acked-by: for, and how it differs from Signed-off-by:
 > >  > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 > >  > +
 > >  > +If a person was not directly involved in the preparation or handling of a
 > >  > +patch but wishes to signify and record their approval of it then they can
 > >  > +arrange to have an Acked-by: line added to the patch's changelog.
 > > 
 > > Acked-by: Dave Jones <davej@redhat.com>
 > 
 > What, no Tested-by: ?

Heh. Indeed.  I think there's room for both fwiw.

	Dave

-- 
http://www.codemonkey.org.uk
