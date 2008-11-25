Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYKYLn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYKYLn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYKYLnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:43:19 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:41080 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYKYLnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:43:18 -0500
Subject: Re: [PATCH] regulator: da903x: make da903x_is_enabled return 0 or 1
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1227601192-23348-1-git-send-email-mike@compulab.co.il>
References: <1227601192-23348-1-git-send-email-mike@compulab.co.il>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 11:43:16 +0000
Message-Id: <1227613396.585.48.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 10:19 +0200, Mike Rapoport wrote:
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/regulator/da903x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied.

Thanks.

Liam

