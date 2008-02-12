Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbYBLJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbYBLJrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760156AbYBLJqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:46:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41485 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759529AbYBLJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:46:35 -0500
Date: Tue, 12 Feb 2008 09:46:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pete MacKay <linux01@architechnical.net>
Cc: linux-kernel@vger.kernel.org, liam.girdwood@wolfsonmicro.com
Subject: Re: [PATCH] Core driver for WM97xx touchscreens
Message-ID: <20080212094633.GA21039@rakim.wolfsonmicro.main>
Mail-Followup-To: Pete MacKay <linux01@architechnical.net>,
	linux-kernel@vger.kernel.org, liam.girdwood@wolfsonmicro.com
References: <60949.69.30.58.166.1202774430.squirrel@architechnical.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60949.69.30.58.166.1202774430.squirrel@architechnical.net>
X-Cookie: Jesus is my POSTMASTER GENERAL ...
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 07:00:30PM -0500, Pete MacKay wrote:
> In wm97xx-core.c, should

> > +int wm97xx_resume(struct device *dev)

> be static?

> Also, should

Yes, and in fact I had both fixes present in the development branch but
had forgotten to cherry pick them over into the upstream branch - thanks
for noticing, I'll respin.
