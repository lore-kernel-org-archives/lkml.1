Return-Path: <linux-kernel-owner+w=401wt.eu-S1765549AbYEWDhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765549AbYEWDhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbYEWDhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:37:21 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:23847 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758061AbYEWDhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:37:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1hvOYf+/q84ZeC+M1lVm3CrxnTvqsgDXQepyW9qlzUT68JihPzXoIXCI40i1aAr5I3ce3Z4ceEnj4WfEvIIEvEvlGBf398W2fMO3brtP6n8zjUMh0J17oDzIWNOq/NOHUzt0elE9DizkG4q2SJziND11a2nKsYjWAiwNFnpk43A=  ;
X-YMail-OSG: p.ORmdUVM1mdiDBfySD3cohOwxDCR.4qmaF1_c9PbG3HSFUz6X.Ju4wXs76fQC5Z1ADJDbrVB9W4ulmREtEVmMB7ifhKlfMslu4kVGuSt0nIz1lJCXsR_IZOeXIqc.8jHgU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Date: Thu, 22 May 2008 19:05:32 -0700
User-Agent: KMail/1.9.9
Cc: Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       fabrizio.garetto@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <20080516193613.28030.13950.stgit@trillian.secretlab.ca> <20080521151928.GA28857@polina.dev.rtsoft.ru>
In-Reply-To: <20080521151928.GA28857@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221905.32288.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008, Anton Vorontsov wrote:
> > +++ b/drivers/spi/spi_of.c
> 
> I think better placement for this is drivers/of, no?

Yes please.

