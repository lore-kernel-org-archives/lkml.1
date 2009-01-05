Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZAEMEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZAEMEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZAEMEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:04:34 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:44844 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbZAEMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:04:34 -0500
Subject: Re: [PATCH] regulator: catch some registration errors
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <1230728059-9392-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1230728059-9392-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 12:04:30 +0000
Message-Id: <1231157070.11643.139.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 12:54 +0000, Mark Brown wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Prevent registration of duplicate "struct regulator" names.
> They'd be unavailable, and clearly indicate something wrong.
> 
> [Edited to remove check for NULL consumer device until we have a
> solution for things like cpufreq -- broonie]
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam

