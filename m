Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0BYKib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:38:31 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56994 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759182Ab0BYKi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:38:29 -0500
Subject: Re: [PATCH 11/14] Regulators: wm831x-xxx - clean up driver data
 after removal
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100224073839.15964.19386.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
	 <20100224073839.15964.19386.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 10:38:25 +0000
Message-ID: <1267094305.4037.133.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 23:38 -0800, Dmitry Torokhov wrote:
> It is a good tone to reset driver data after unbinding the device.
> Also set up drivers owner.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

