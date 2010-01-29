Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494Ab0A2OB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0A2OB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725Ab0A2OB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:01:27 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:57862 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753668Ab0A2OB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:01:27 -0500
Date: Fri, 29 Jan 2010 17:01:24 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.33] power_supply: Handle missing platform data
 gracefully
Message-ID: <20100129140124.GA14935@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1264625001-3963-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1264625001-3963-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 08:43:21PM +0000, Mark Brown wrote:
> Don't unconditionally dereference the WM97xx core platform data since
> it may not be present, causing an oops.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied to battery-2.6.33, thanks!
