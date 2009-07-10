Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZGJQAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZGJQAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZGJQAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:00:42 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:53047 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZGJQAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:00:42 -0400
Subject: Re: [PATCH] regulator: Define full constraints function with
 REGULATOR disabled
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1247150671-23365-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1247150671-23365-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 17:00:32 +0100
Message-Id: <1247241632.4225.175.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 15:44 +0100, Mark Brown wrote:
> This allows machine drivers to build without ifdefs if they have
> full constraints. Suggested by machine drivers contributed by
> Haojian Zhuang <haojian.zhuang@gmail.com>.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  include/linux/regulator/machine.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 

Applied.

Thanks

Liam

