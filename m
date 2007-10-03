Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbXJCEKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbXJCEKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbXJCEKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:10:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXJCEKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:10:34 -0400
Message-ID: <4703161E.8040603@zytor.com>
Date: Tue, 02 Oct 2007 21:10:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Jeff Garzik <jeff@garzik.org>, ak@suse.de,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Document x86-64 iommu kernel parameters
References: <20071003013413.GA17717@havoc.gtf.org>	<20071002192209.09b2fbda.randy.dunlap@oracle.com>	<4702FEC7.3000000@garzik.org> <20071002210125.85b84add.randy.dunlap@oracle.com>
In-Reply-To: <20071002210125.85b84add.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> Maybe we can/should merge the doc files along with the x86 arch merge.
> 

Well, the x86 merge is pretty much mechanical.  It should be followed up 
with a lot of manual merging.

	-hpa
