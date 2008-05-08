Return-Path: <linux-kernel-owner+w=401wt.eu-S1765223AbYEHRN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765223AbYEHRN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764708AbYEHRNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:13:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764694AbYEHRNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:13:44 -0400
Date: Thu, 8 May 2008 13:12:54 -0400
From: Rik van Riel <riel@redhat.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 1/9] Change the idr structure
Message-ID: <20080508131254.311b3772@bree.surriel.com>
In-Reply-To: <20080507113735.137310000@bull.net>
References: <20080507113553.395937000@bull.net>
	<20080507113735.137310000@bull.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 13:35:54 +0200
Nadia.Derbey@bull.net wrote:

> [PATCH 01/09]
> 
> This patch adds an rcu_head to the idr_layer structure in order to free it
> after a grace period.
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
