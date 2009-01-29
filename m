Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZA2S3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZA2S3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZA2S3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:29:15 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1824 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZA2S3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:29:14 -0500
Date: Thu, 29 Jan 2009 18:29:05 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: sameo@openedhand.com, lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090129182904.GB7032@sirena.org.uk>
References: <4981CB45.8010108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4981CB45.8010108@gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: tries reaches -1
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 04:29:09PM +0100, Roel Kluin wrote:
> With a postfix decrement tries will reach -1 rather than 0,
> so the warning will not be issued even upon timeout.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks.  I'll add this to my queue of things I'm pushing to
Samuel.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
