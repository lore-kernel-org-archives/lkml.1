Return-Path: <linux-kernel-owner+w=401wt.eu-S1763395AbXGaOUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763395AbXGaOUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763432AbXGaOUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:20:30 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:35825 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763269AbXGaOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:20:29 -0400
Subject: Re: [Patch 15/16] Remove unnecesary kmalloc casts in the scsi
	drivers.
From: James Bottomley <James.Bottomley@SteelEye.com>
To: jack@hawkeye.stone.uk.eu.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <20070731125447.639642000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
	 <20070731125447.639642000@hawkeye.stone.uk.eu.org>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 09:20:28 -0500
Message-Id: <1185891628.3468.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 13:53 +0100, jack@hawkeye.stone.uk.eu.org wrote:
> plain text document attachment
> (drivers_scsi_remove_kmalloc_casts.patch)
> Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
> 
> CC: James Bottomley <james.bottomley@steeleye.com>
> 
> ---
>  drivers/scsi/advansys.c |    2 +-
>  drivers/scsi/osst.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

a) You need to copy linux-scsi on SCSI patches, but 
b) The advansys driver is in the process of being rewritten, so the
chances of this no longer applying are very high.  If you send it to the
list or matthew wilcox, he can fold it in to his updates.

James


