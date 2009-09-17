Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbZIQRae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbZIQRae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZIQRae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:30:34 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52035 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZIQRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:30:33 -0400
Date: Thu, 17 Sep 2009 13:23:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Price <andy@andrewprice.me.uk>, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: rt2x00dev.c:405: error: =?utf-8?Q?too_?=
	=?utf-8?Q?few_arguments_to_function_=E2=80=98rt2x00crypto=5Frx=5Finsert?=
	=?utf-8?B?X2l24oCZ?=
Message-ID: <20090917172358.GC2577@tuxdriver.com>
References: <20090917154138.GA31844@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090917154138.GA31844@sucs.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 04:41:39PM +0100, Andrew Price wrote:
> Hi Ivo,
> 
> Apologies if this has already been reported. Building today's mainline
> kernel (ab86e5) I'm seeing this error:
> 
> drivers/net/wireless/rt2x00/rt2x00dev.c: In function ‘rt2x00lib_rxdone’:
> drivers/net/wireless/rt2x00/rt2x00dev.c:405: warning: passing argument 3 of ‘rt2x00crypto_rx_insert_iv’ makes integer from pointer without a cast
> drivers/net/wireless/rt2x00/rt2x00dev.c:405: error: too few arguments to function ‘rt2x00crypto_rx_insert_iv’

Strange...I don't see this warning.  Are you sure you have a clean checkout?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
