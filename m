Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZAVOL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZAVOL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZAVOLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:11:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3188 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZAVOLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:11:49 -0500
Date: Thu, 22 Jan 2009 14:11:46 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: add unset_regulator_supplies to fix regulator_unregister
Message-ID: <20090122141146.GG19720@sirena.org.uk>
References: <49787BFD.3020702@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49787BFD.3020702@compulab.co.il>
X-Cookie: Remember: use logout to logout.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 04:00:29PM +0200, Mike Rapoport wrote:
> Currently regulator_unregister does not clear regulator <--> consumer
> mapping.
> This patch introduces unset_regulator_supplies that clear the map.

> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
