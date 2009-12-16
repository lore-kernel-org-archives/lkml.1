Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbZLPP5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbZLPP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZLPP5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:57:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38354 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755550AbZLPP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:57:43 -0500
Date: Wed, 16 Dec 2009 15:57:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: joe@perches.com, alsa-devel@alsa-project.org, clemens@ladisch.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix disable of SPDIF on STAC9766 codec
Message-ID: <20091216155739.GA31418@rakim.wolfsonmicro.main>
References: <20091216015344.21806.5403.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216015344.21806.5403.stgit@terra>
X-Cookie: Flattery will get you everywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 08:53:44PM -0500, Jon Smirl wrote:
> Change code so that switching to playing music through the analog output disables SPDIF
> out instead of disabling it when stream ends.
> 
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>

Applied, thanks, with word-wrapping and whatnot in the commit message.
