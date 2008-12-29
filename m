Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYL2MVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYL2MVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYL2MVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:21:01 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:50545 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYL2MVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KPadVRA9lDsxBTZmvTyGfVbBa7+6Gf9+R7iG00NIrHULeAygwLL8O4fJTSj57dyLBz
         b47fsLXoFy9YiBydPLiFLJzsCcgDegYtH6URvO9uuZP+4RMa9KkLIT9ZhvR6DUj5uexq
         nJ0JcgNuuJAAiaUkbBvBPs8mqZv5825JgTWOw=
Message-ID: <8bd0f97a0812290420m2cd2aa8bv7b3dc2e67287f0f7@mail.gmail.com>
Date: Mon, 29 Dec 2008 07:20:59 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux byteorder headers: convert to __inline__ for userspace
In-Reply-To: <1230360583-6683-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230360583-6683-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 01:49, Mike Frysinger <vapier@gentoo.org> wrote:
> Use __inline__ rather than inline for all the functions exported to
> userspace.

this patch can be ignored due to the autoconvert patch proposed for
headers_install.pl
-mike
