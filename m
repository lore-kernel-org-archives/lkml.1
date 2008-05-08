Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbYEHSDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbYEHSDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYEHSDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:03:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYEHSDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:03:02 -0400
Date: Thu, 8 May 2008 14:02:19 -0400
From: Rik van Riel <riel@redhat.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 7/9] Make idr_remove rcu-safe
Message-ID: <20080508140219.74c5d886@bree.surriel.com>
In-Reply-To: <20080507113737.562143000@bull.net>
References: <20080507113553.395937000@bull.net>
	<20080507113737.562143000@bull.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 13:36:00 +0200
Nadia.Derbey@bull.net wrote:

> [PATCH 07/09]
> 
> This patch introduces the free_layer() routine: it is the one that actually
> frees memory after a grace period has elapsed.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
