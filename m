Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbZKFBmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbZKFBmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZKFBma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:42:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42184
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757592AbZKFBma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:42:30 -0500
Date: Thu, 05 Nov 2009 17:42:55 -0800 (PST)
Message-Id: <20091105.174255.73080668.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] sysctl: sparc Use the compat_sys_sysctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1257468114-6823-8-git-send-email-ebiederm@xmission.com>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
	<1257468114-6823-8-git-send-email-ebiederm@xmission.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu,  5 Nov 2009 16:41:51 -0800

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that we have a generic 32bit compatibility implementation
> there is no need for sparc to implement it's own.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: David S. Miller <davem@davemloft.net>
