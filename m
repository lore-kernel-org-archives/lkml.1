Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYKTOEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYKTOEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYKTOEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:04:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57008 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751271AbYKTOEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:04:31 -0500
Date: Thu, 20 Nov 2008 14:04:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Fix define values of CS1_HIB_MODE.
Message-ID: <20081120140427.GA27464@rakim.wolfsonmicro.main>
References: <492548F3.6090307@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492548F3.6090307@miraclelinux.com>
X-Cookie: You humans are all alike.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 08:24:35PM +0900, Naohiro Ooiwa wrote:

> I found a little mistake.
> The define values are wrong.

> It is written in the WM8350 DATA SHEET Rev 3.4 P285 that
> CS1_HIB_MODE(bit 12) is disable at "1".

I will double check but I believe this to be a datasheet error - if it
is it will be corrected in the datasheet.
