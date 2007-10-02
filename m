Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXJBX2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXJBX2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbXJBX20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:28:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43606 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbXJBX2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:28:25 -0400
Date: Tue, 2 Oct 2007 18:28:19 -0500
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
Message-ID: <20071002232819.GN4338@austin.ibm.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <20070924123531.GC30855@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924123531.GC30855@shadowen.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 01:35:31PM +0100, Andy Whitcroft wrote:
> Seeing the following from an older power LPAR, pretty sure we had
> this in the previous -mm also:

I haven't forgetten about this ... and am looking at it now.
Seems that whenever I go to reserve the machine pSeries-102,
someone else is using it :-)

--linas
