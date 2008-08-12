Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYHLSBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYHLSBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYHLSBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:01:13 -0400
Received: from khc.piap.pl ([195.187.100.11]:41580 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYHLSBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:01:12 -0400
To: Andy Whitcroft <apw@shadowen.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive in checkpatch
References: <Pine.LNX.4.44L0.0808121017510.2509-100000@iolanthe.rowland.org>
	<m3d4kefe0x.fsf@maximus.localdomain> <20080812171800.GA29207@brain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 12 Aug 2008 20:01:10 +0200
In-Reply-To: <20080812171800.GA29207@brain> (Andy Whitcroft's message of "Tue\, 12 Aug 2008 18\:18\:00 +0100")
Message-ID: <m3wsim3yft.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@shadowen.org> writes:

> The recommendations it makes match the style of the whole, which new
> contributions should follow.

But there isn't any "style of the whole". Existing styles differ.
While I guess there is some agreement about the base (tab width,
mostly K&R, don't do "char* ptr" etc.), the rest are simply views of
single persons.
This is IMHO fine as long as it's useful for the community, but not
past this point.
-- 
Krzysztof Halasa
