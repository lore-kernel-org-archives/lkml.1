Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZAEU2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZAEU2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZAEU2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:28:32 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:50589 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZAEU2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:28:31 -0500
Date: Mon, 5 Jan 2009 21:28:29 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.28 1/3] PCI-quirks: Unhide MCH5/6 memory controller configuration device
Message-ID: <20090105202829.GB26115@rere.qmqm.pl>
References: <20081223215030.GA32525@rere.qmqm.pl> <20090101190254.GA22845@rere.qmqm.pl> <200901051120.35726.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901051120.35726.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 11:20:35AM -0800, Jesse Barnes wrote:
> On Thursday, January 1, 2009 11:02 am Micha³ Miros³aw wrote:
> > Some BIOSes hide 'overflow' device (dev #6) for i82875P/PE chipsets.
> > The same happens for i82865P/PE. Add a quirk to enable this device.
> > This allows i82875 EDAC driver to bind to chipset's dev #6 and not
> > dev #0 as the latter is used by AGP driver.
> >
> > This is rebased against 2.6.28 vanilla kernel, including trimming
> > of long lines.
[cut]
> This one doesn't apply for me, can you resend a new one against my linux-next 
> branch?

Sure. Following.
  -- Micha³ Miros³aw

