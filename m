Return-Path: <linux-kernel-owner+w=401wt.eu-S1161690AbXDXHtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161690AbXDXHtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161699AbXDXHtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:49:12 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:26332 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161690AbXDXHtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:49:11 -0400
In-Reply-To: <1177347358.28021.24294.camel@hal.voltaire.com>
Subject: Re: [ofa-general] [PATCH] eHCA: Add "Modify Port" verb
To: Hal Rosenstock <halr@voltaire.com>
Cc: OF-General <general@lists.openfabrics.org>,
       general-bounces@lists.openfabrics.org,
       Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFD6A63EF5.4BF41EFD-ONC12572C7.002ACA29-C12572C7.002AF268@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Tue, 24 Apr 2007 23:48:48 +0200
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 24/04/2007 09:49:05
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Hal,
you are correct,
with the current firmware version it will fail later.

Christoph R.

general-bounces@lists.openfabrics.org wrote on 23.04.2007 18:55:59:

> Hi Joachim,
>
> On Mon, 2007-04-23 at 12:23, Joachim Fenkes wrote:
> > Add "Modify Port" verb support to eHCA driver.
> > ib_cm needs this to initialize properly.
>
> I didn't think IB_PORT_SM was allowed (as QP0 is not exposed) or does
> this just fail later when it is attempted to be actually set ?
>
> -- Hal

