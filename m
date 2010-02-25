Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0BYKjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:39:22 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49997 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab0BYKjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:39:18 -0500
Subject: Re: [PATCH 14/14] Regulators: max8925-regulator - clean up driver
 data after removal
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100224073855.15964.38061.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
	 <20100224073855.15964.38061.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 10:39:14 +0000
Message-ID: <1267094354.4037.137.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 23:38 -0800, Dmitry Torokhov wrote:
> It is a good tone to reset driver data after unbinding the device.
> Also change find_regulator_info() fro inline to __devinit - let compiler
> figure out if it wants it to be inlined or not.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

