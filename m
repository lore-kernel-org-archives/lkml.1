Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbZD1Mqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbZD1Mqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZD1MqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:46:08 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:55612 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbZD1MqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:46:07 -0400
Subject: Re: [PATCH 1/1] regulator/bq24022: fix bug in is_enabled function
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1240918454-25118-1-git-send-email-philipp.zabel@gmail.com>
References: <1240918454-25118-1-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 13:46:03 +0100
Message-Id: <1240922763.14165.134.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 13:34 +0200, Philipp Zabel wrote:
> This seems to be fallout from last October's regulator core rework.
> It got noticed only because of recent regulator framework changes.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/regulator/bq24022.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 

Applied.

Thanks

Liam


