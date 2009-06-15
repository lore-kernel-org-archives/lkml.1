Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbZFOSjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbZFOSjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZFOSiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:38:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59256 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZFOSiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:38:54 -0400
Date: Mon, 15 Jun 2009 19:38:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lrg@slimlogic.co.uk, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] regulator: add check index of wm8350->pmic.pdev[]
Message-ID: <20090615183855.GK6106@sirena.org.uk>
References: <4A36AF6F.6060005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A36AF6F.6060005@gmail.com>
X-Cookie: Prunes give you a run for your money.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:30:39PM +0200, Roel Kluin wrote:
> Ensure that reg is within the bounds of array wm8350->pmic.pdev[].
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
