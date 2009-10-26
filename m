Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZJZNkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZJZNkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZJZNkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:40:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:23578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZJZNkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:40:17 -0400
Subject: Re: [PATCH 1/6] regulator: Also lift apply_uV into
 machine_constraints_voltage()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 13:40:17 +0000
Message-ID: <1256564417.3530.329.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 16:31 +0100, Mark Brown wrote:
> It makes sense to do all the voltage configuration in the one split
> out function.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |   35 ++++++++++++++++++-----------------
>  1 files changed, 18 insertions(+), 17 deletions(-)
> 

All applied.

Thanks

Liam

