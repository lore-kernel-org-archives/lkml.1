Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbYEHSEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbYEHSEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYEHSDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:03:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYEHSDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:03:52 -0400
Date: Thu, 8 May 2008 13:58:22 -0400
From: Rik van Riel <riel@redhat.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 6/9] Make idr_find rcu-safe
Message-ID: <20080508135822.4b704789@bree.surriel.com>
In-Reply-To: <20080507113737.158241000@bull.net>
References: <20080507113553.395937000@bull.net>
	<20080507113737.158241000@bull.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 13:35:59 +0200
Nadia.Derbey@bull.net wrote:

> [PATCH 06/09]
> 
> This is a patch that makes idr_find rcu-safe: it can now be called inside an
> rcu_read critical section.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
