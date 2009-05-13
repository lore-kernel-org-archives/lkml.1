Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbZEMWK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbZEMWK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761568AbZEMWKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:10:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:40370 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761437AbZEMWKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:10:31 -0400
Cc: akpm@linux-foundation.org, davem@davemloft.net,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org
Message-Id: <5CAABE74-2F06-420C-B24A-A6EF63C023F8@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Li Yang <leoli@freescale.com>
In-Reply-To: <1242117363-14949-6-git-send-email-leoli@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 6/6] rio: fix section mismatch
Date: Wed, 13 May 2009 17:08:10 -0500
References: <1242117363-14949-1-git-send-email-leoli@freescale.com> <1242117363-14949-2-git-send-email-leoli@freescale.com> <1242117363-14949-3-git-send-email-leoli@freescale.com> <1242117363-14949-4-git-send-email-leoli@freescale.com> <1242117363-14949-5-git-send-email-leoli@freescale.com> <1242117363-14949-6-git-send-email-leoli@freescale.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12, 2009, at 3:36 AM, Li Yang wrote:

> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> drivers/rapidio/rio-scan.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)


applied to next

- k
