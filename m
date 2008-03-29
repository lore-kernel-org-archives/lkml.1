Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYC2SrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYC2SrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbYC2Sqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:46:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:42018 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYC2Sqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l+eWFpb4J/FEBXVr8Cc3fSVI8WFHMX1KtqYPO6H8ZbfBicpjsVHy6ifCJ8UIPywvs4TVoeOAbXYcL5mbP3uVOeAIalBA/2WvZYkKqDPINbECUE2b4Wo1KfKVrhAzhPI3hCnFogG7Zm8NsBnE2qQSiWVT2cOG4KNpXwB4yxVdAnw=
Subject: Re: [PATCH] NULL noise: drivers/misc
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1JfRQ4-0002Za-IC@ZenIV.linux.org.uk>
References: <E1JfRQ4-0002Za-IC@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 11:46:57 -0700
Message-Id: <1206816417.6543.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:07 +0000, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/misc/fujitsu-laptop.c |    2 +-
>  drivers/misc/ibmasm/module.c  |    2 +-
>  drivers/misc/lkdtm.c          |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 

Not duplicated in -mm, please apply.

Harvey

