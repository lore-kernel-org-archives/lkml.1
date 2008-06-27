Return-Path: <linux-kernel-owner+w=401wt.eu-S1764361AbYF0W56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764361AbYF0W56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761279AbYF0W5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:57:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761443AbYF0W5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:57:41 -0400
Date: Fri, 27 Jun 2008 15:57:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/13] EDAC mpc85xx fix pci ofdev
Message-Id: <20080627155701.72d30927.akpm@linux-foundation.org>
In-Reply-To: <48652db9.0Y8LuCqRcWSJ9Ih7%dougthompson@xmission.com>
References: <48652db9.0Y8LuCqRcWSJ9Ih7%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 12:13:13 -0600
dougthompson@xmission.com wrote:

> From:	Dave Jiang <djiang@mvista.com>
> 
> Applied to linux-2.6.26-rc5-mm3
> 
> Converting PCI err device from platform to open firmware of_dev to comply with
> powerpc schemes.

This one doesn't apply due to later changes which should be in 2.6.26-rc8.
