Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZFWS4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZFWS4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZFWS42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:56:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:59928 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZFWS41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:56:27 -0400
To: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, drzeus-mmc@drzeus.cx
Subject: Re: [PATCH v5] DaVinci: MMC: MMC/SD controller driver for DaVinci family.
References: <1245757600-1073-1-git-send-email-vipin.bhandari@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 23 Jun 2009 11:56:27 -0700
In-Reply-To: <1245757600-1073-1-git-send-email-vipin.bhandari@ti.com> (Vipin Bhandari's message of "Tue\, 23 Jun 2009 07\:46\:40 -0400")
Message-ID: <87zlbykcdg.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vipin Bhandari <vipin.bhandari@ti.com> writes:

> This patch adds support for MMC/SD controller driver for all DaVinci family
> SoC. This patch supports davinci family SoC's DM6446, DM355, DM365 and
> DA830/OMAPL137.
>
> The patch has been tested on DM355 EVM.
>
> The MMCSD controller specifications for DM355 can be found at
> http://focus.ti.com/general/docs/litabsmultiplefilelist.tsp?literatureNumber=spruee2c
>
> Signed-off-by: Vipin Bhandari <vipin.bhandari@ti.com>
> Signed-off-by: Purshotam Kumar <purushotam@ti.com>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

