Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYAWJnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYAWJnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYAWJnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:43:25 -0500
Received: from ozlabs.org ([203.10.76.45]:41205 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYAWJnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:43:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] fix drivers/lguest Makefile entry
Date: Wed, 23 Jan 2008 20:42:35 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <12006226032537-git-send-email-gcosta@redhat.com>
In-Reply-To: <12006226032537-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801232042.36173.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 13:16:43 Glauber de Oliveira Costa wrote:
> It should depend on CONFIG_LGUEST, not CONFIG_LGUEST_GUEST

Actually, it needs both.  Some parts are guest, some are host.

Cheers,
Rusty.

