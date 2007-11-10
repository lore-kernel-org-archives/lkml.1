Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbXKJAvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbXKJAvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 19:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXKJAv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 19:51:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbXKJAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 19:51:25 -0500
Date: Fri, 9 Nov 2007 16:51:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: casey@schaufler-ca.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, method@manicmethod.com
Subject: Re: [PATCH 1/2]  NetLabel: Introduce a new kernel configuration API
 for NetLabel - Version 11 (2.6.24-rc2) Smack: Simplified Mandatory Access
 Control Kernel
Message-Id: <20071109165119.f40248b3.akpm@linux-foundation.org>
In-Reply-To: <4733E6A3.2070307@schaufler-ca.com>
References: <4733E6A3.2070307@schaufler-ca.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2007 20:48:35 -0800
Casey Schaufler <casey@schaufler-ca.com> wrote:

> From: Paul Moore <paul.moore@hp.com>
> 
> Add a new set of configuration functions to the NetLabel/LSM API so that
> LSMs can perform their own configuration of the NetLabel subsystem without
> relying on assistance from userspace.
> 
> Signed-off-by: Paul Moore <paul.moore@hp.com>

You sent it, so this patch needs a Signed-off-by:you, please.
