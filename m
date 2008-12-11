Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYLKQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYLKQOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbYLKQOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:14:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33764 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755424AbYLKQOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:14:04 -0500
Date: Thu, 11 Dec 2008 16:14:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: breakage in linux-next sound/soc/blackfin/bf5xx-i2s.c
Message-ID: <20081211161402.GA24645@rakim.wolfsonmicro.main>
References: <8bd0f97a0812110802k1faa1c67tc81b4bb5282a3d17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0812110802k1faa1c67tc81b4bb5282a3d17@mail.gmail.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 11:02:24AM -0500, Mike Frysinger wrote:
> your recent change 3f4b783cfd (ASoC: Register platform DAIs) is
> incorrect for sound/soc/blackfin/bf5xx-i2s.c.

Fixed, thanks.
