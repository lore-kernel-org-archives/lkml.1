Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZL3XBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZL3XBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZL3XBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:01:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZL3XBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:01:51 -0500
Date: Wed, 30 Dec 2009 18:01:48 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Vikram Kandukuri <Vikram.Kandukuri@Atheros.com>
Cc: "marcel@holtmann.org" <marcel@holtmann.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] DFU Driver for Atheros bluetooth chipset AR3011
Message-ID: <20091230230148.GH30201@bombadil.infradead.org>
References: <20091124101007.GC7551@atheros-laptop> <44EE5C37ADC36343B0625A05DD408C485069714222@CHEXMB-01.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C485069714222@CHEXMB-01.global.atheros.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 05:14:37PM +0530, Vikram Kandukuri wrote:
> Hi Marcel,
> 
> Signed-off-by: Vikram Kandukuri <Vikram.Kandukuri@atheors.com>
> Signed-off-by: Alicke Xu <sxu@atheros.com>
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Can you resubmit and take care of space damage? Please run through
checkpatch and also please ensure you can apply it via git am foo.patch
before submitting.

  Luis
