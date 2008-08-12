Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYHLRYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYHLRYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYHLRYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:24:12 -0400
Received: from saeurebad.de ([85.214.36.134]:36529 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYHLRYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:24:11 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Documentation: describe bootmem_debug kernel parameter
References: <20080812084741.GC5952@alberich.amd.com>
Date: Tue, 12 Aug 2008 19:23:47 +0200
In-Reply-To: <20080812084741.GC5952@alberich.amd.com> (Andreas Herrmann's
	message of "Tue, 12 Aug 2008 10:47:41 +0200")
Message-ID: <87skta2llo.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andreas Herrmann <andreas.herrmann3@amd.com> writes:

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  Documentation/kernel-parameters.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> "bootmem_debug" is not mentioned in kernel-parameters.txt. Recently I
> had to use that kernel option and I think it should be documented.

You are right, thanks.

	Hannes
