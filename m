Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZGTMZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZGTMZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 08:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZGTMZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 08:25:03 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52835 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZGTMZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 08:25:01 -0400
Date: Mon, 20 Jul 2009 14:24:57 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Molton <spyro@f2s.com>,
       Anton Vorontsov <cbou@mail.ru>, Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/3] pda-power: add set_charged functionaltity
Message-ID: <20090720122457.GR9464@buzzloop.caiaq.de>
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 05:44:02PM +0200, Daniel Mack wrote:
> This adds a function to let the power supply core know that the battery
> is fully charged now. This can be done by watching a GPIO line, for
> example.
> 
> Some battery drivers might need that information to calibrate
> themselves.

Any comments about the last patch series? I've sent one inlined in a
reply and three more apart from it, which might have been confusing. Do
you want me to resend it as one block?

Thanks,
Daniel
