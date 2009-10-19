Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZJSPMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZJSPMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZJSPMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:12:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56921 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651AbZJSPMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:12:50 -0400
Date: Mon, 19 Oct 2009 16:12:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/14] sound/soc: Move dereference after NULL test
Message-ID: <20091019151251.GB29796@sirena.org.uk>
References: <Pine.LNX.4.64.0910170832300.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910170832300.9213@ask.diku.dk>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 08:32:56AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test on jack is needed, then the derefernce should be after the
> NULL test.

Applied, thanks.
