Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYDRXdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYDRXdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYDRXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:33:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60257
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbYDRXdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:33:24 -0400
Date: Fri, 18 Apr 2008 16:33:25 -0700 (PDT)
Message-Id: <20080418.163325.74133866.davem@davemloft.net>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] [SPARC] minor irq handler cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <2c534626fe10b5c62c552cdacd96e07e94e232ca.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
	<2c534626fe10b5c62c552cdacd96e07e94e232ca.1208559659.git.jgarzik@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 18 Apr 2008 19:22:46 -0400 (EDT)

> - mark timer_interrupt() static
> 
> - sparc_floppy_request_irq() prototype should use irq_handler_t
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
