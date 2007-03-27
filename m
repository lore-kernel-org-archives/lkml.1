Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXC0LHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXC0LHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 07:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXC0LHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 07:07:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:28784 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbXC0LG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 07:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RhNwVV6rjrvmVjr+F7H68smc/JZDkIUZJumnDqi03q8i0OGfSrb5ED61mVRMNDPfIjSEKMxd4IUTLwZGiCIMGGPLr/FH3K95HJXMqxc4EjL1rVaRPtgtyf5Z6wPTE6A4hGY2ALZg77ydH8bVhQ9124IYEi6BIyTd8bSSG3jiqWo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm1
Date: Tue, 27 Mar 2007 13:15:04 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
In-Reply-To: <20070326205706.a750bb35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703271315.04674.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 27 March 2007, Andrew Morton wrote:

> - The IDE tree has been dropped because of a general mess against the recent
>   IDE merge into mainline.  I'll restore it when Bart fixes it up.

fixed
