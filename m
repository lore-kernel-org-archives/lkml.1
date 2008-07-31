Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbYGaBTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbYGaBTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYGaBS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:18:57 -0400
Received: from c60.cesmail.net ([216.154.195.49]:30310 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYGaBS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:18:57 -0400
Subject: Re: [PATCH 3/8] wireless: replace __FUNCTION__ with __func__
From: Pavel Roskin <proski@gnu.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1217311294.23389.26.camel@brick>
References: <1217311294.23389.26.camel@brick>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 21:18:55 -0400
Message-Id: <1217467135.3616.11.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 23:01 -0700, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/net/wireless/airo.c                   |   16 ++++++++--------
>  drivers/net/wireless/hermes.c                 |    2 +-

For hermes.c:

Signed-off-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
