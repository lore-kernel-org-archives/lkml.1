Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYKYQAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYKYQAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYKYQAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:00:33 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:46789 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751193AbYKYQAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:00:32 -0500
Date: Tue, 25 Nov 2008 16:00:25 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] arch/mips/alchemy: change strict_strtol to
	strict_strtoul
Message-ID: <20081125160025.GA18083@linux-mips.org>
References: <Pine.LNX.4.64.0811251412010.11897@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811251412010.11897@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 02:12:32PM +0100, Julia Lawall wrote:

> Since memsize is unsigned, it would seem better to use strict_strtoul that
> strict_strtol.

Thanks, applied.

  Ralf
