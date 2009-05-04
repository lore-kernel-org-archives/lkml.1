Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZEDVCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZEDVCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZEDVCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:02:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbZEDVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:02:45 -0400
Date: Mon, 4 May 2009 13:55:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: avorontsov@ru.mvista.com
Cc: galak@kernel.crashing.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] Some work for spi_mpc83xx driver, spi-mmc support
 for MPC8610HPCD
Message-Id: <20090504135504.a6a6afcf.akpm@linux-foundation.org>
In-Reply-To: <20090430234739.GA27709@oksana.dev.rtsoft.ru>
References: <20090430234739.GA27709@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 03:47:39 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Here are few patches that are needed to support spi-mmc slot on
> MPC8610HPCD PowerPC boards:
> 
> [1/9] spi_mpc83xx: Handles other Freescale processors
> [2/9] spi_mpc83xx: Quieten down the "Requested speed is too low" message
> [3/9] spi_mpc83xx: Add small delay after asserting chip-select line
> [4/9] powerpc/86xx: Add MMC SPI support for MPC8610HPCD boards
> 

Some or all of these seem appropriate to 2.6.30 and perhaps even -stable?
