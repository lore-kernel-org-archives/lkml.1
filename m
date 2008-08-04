Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYHDNcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYHDNcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYHDNbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:31:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52128 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbYHDNby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:31:54 -0400
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
In-Reply-To: <20080804043053.GB10519@colo.lackof.org>
References: <1217786532.4179.24.camel@localhost.localdomain>
	 <20080804043053.GB10519@colo.lackof.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 08:31:48 -0500
Message-Id: <1217856708.3318.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 22:30 -0600, Grant Grundler wrote:
> On Sun, Aug 03, 2008 at 01:02:12PM -0500, James Bottomley wrote:
> > We're getting a lot of storage drivers blamed for interrupt misrouting
> > issues.  This patch provides a standard way of reporting the problem
> > ... and, if possible, correcting it.
> 
> James,
> Can you add a paragraph to Documentation/pci.txt about the usage
> of the new API?

When there actually is a new API, sure.

James


