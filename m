Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZHJSng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZHJSng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZHJSnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:43:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43032 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZHJSnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:43:33 -0400
Date: Mon, 10 Aug 2009 19:43:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: sound tree build warning
Message-ID: <20090810184331.GD24947@sirena.org.uk>
References: <20090810141518.cf9a3a2f.sfr@canb.auug.org.au> <s5hws5cm89y.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hws5cm89y.wl%tiwai@suse.de>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 09:34:49AM +0200, Takashi Iwai wrote:

> Looks like a forgotten piece since the reg-cache branch merge.
> Mark, could you clean up?

The changes I pushed earlier today did so.
