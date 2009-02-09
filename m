Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZBIMWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZBIMWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZBIMWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:22:46 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:27627 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZBIMWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:22:45 -0500
Date: Mon, 9 Feb 2009 13:22:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, frank@f-seidel.de,
       w.sang@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, fseidel@suse.de
Subject: Re: [PATCHv2 1/2] i2c: add missing KERN_* constants to printks
Message-ID: <20090209132230.66bc4730@hyperion.delvare>
In-Reply-To: <498EE9C9.4080002@suse.de>
References: <498C3EEA.5060508@suse.de>
	<498EE9C9.4080002@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 15:18:49 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the i2c subsystem.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/i2c/algos/i2c-algo-pcf.c  |    2 +-
>  drivers/i2c/busses/i2c-pca-isa.c  |    5 +++--
>  drivers/i2c/busses/i2c-powermac.c |    3 ++-
>  drivers/i2c/busses/i2c-pxa.c      |    9 +++++----
>  4 files changed, 11 insertions(+), 8 deletions(-)

Applied, thanks.

-- 
Jean Delvare
