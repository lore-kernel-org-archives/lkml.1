Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYCDJOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYCDJOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYCDJOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:14:00 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:56352 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365AbYCDJN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:13:59 -0500
Date: Tue, 4 Mar 2008 10:12:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/14] i2c: replace remaining __FUNCTION__ occurrences
Message-ID: <20080304101218.0e333bbd@hyperion.delvare>
In-Reply-To: <1204600184.22933.84.camel@brick>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
	<1204600184.22933.84.camel@brick>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Harvey,

On Mon, 03 Mar 2008 19:09:44 -0800, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/i2c/busses/i2c-davinci.c |    6 ++--
>  drivers/i2c/busses/i2c-pmcmsp.c  |    4 +-
>  drivers/i2c/busses/i2c-pnx.c     |   44 +++++++++++++++++++-------------------
>  drivers/i2c/busses/i2c-pxa.c     |    2 +-
>  drivers/i2c/busses/i2c-s3c2410.c |    4 +-
>  drivers/i2c/chips/isp1301_omap.c |   28 ++++++++++++------------
>  drivers/i2c/i2c-core.c           |    2 +-
>  7 files changed, 45 insertions(+), 45 deletions(-)

Patch applied, thanks.

-- 
Jean Delvare
