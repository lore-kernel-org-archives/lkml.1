Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744Ab0A2UBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0A2UBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688Ab0A2UBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:01:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:54283 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab0A2UBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:01:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,370,1262592000"; 
   d="scan'208";a="591591985"
Date: Fri, 29 Jan 2010 21:02:03 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] WM8994 core driver
Message-ID: <20100129200202.GD23130@sortiz.org>
References: <20100125192554.GA11200@rakim.wolfsonmicro.main>
 <20100129181500.GD19270@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129181500.GD19270@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jan 29, 2010 at 06:15:00PM +0000, Mark Brown wrote:
> On Mon, Jan 25, 2010 at 07:25:54PM +0000, Mark Brown wrote:
> > This patch series implements core support for the WM8994 audio CODEC.
> > Since the WM8994 is a large device and includes both GPIOs and
> > integrated LDOs which need be represented via the relevant subsystems
> > for integration with the rest of the kernel a MFD core device is
> > provided to manage chip access.
> 
> Unfortunately I discovered another sync issue with the platform data.
> I'll resend the series shortly with that corrected, please ignore this
> posting.
Got the latest one, all 3 patches applied, thanks.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
