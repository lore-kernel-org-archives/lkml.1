Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbZJILIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbZJILIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbZJILIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:08:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38876 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbZJILIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:08:31 -0400
Date: Fri, 9 Oct 2009 12:07:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
       sedji.gaouaou@atmel.com, linux-kernel@vger.kernel.org
Message-ID: <20091009110747.GA7104@sirena.org.uk>
References: <1255018789-3437-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255018789-3437-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sound: at91sam9g20ek_2mmc board uses same audio
 connexion as at91sam9g20ek
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 06:19:49PM +0200, Nicolas Ferre wrote:
> The modified revision of at91sam9g20 Evaluation Kit rev. C and onwards share
> with previous ones its audio connexion to Wolfson wm8731. Modify the SoC file
> to extend the machine ID checking.

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied, thanks.
