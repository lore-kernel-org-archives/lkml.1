Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434Ab0AZMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0AZMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526Ab0AZMN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:13:58 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:8046 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab0AZMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:13:57 -0500
Subject: Re: [PATCH] regulator: Add WM8994 regulator support
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1264448517-12048-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1264448517-12048-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 12:13:47 +0000
Message-ID: <1264508027.3067.77.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 19:41 +0000, Mark Brown wrote:
> The WM8994 contains two LDOs with mixed hardware/software control to
> minimise the number of external supplies required while delivering
> optimal voltages to minimise power consumption.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied to for-2.6.34

Will move to next when mfd parts are in next.

Thanks

Liam

