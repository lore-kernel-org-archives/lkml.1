Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbXHGEJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbXHGEJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 00:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXHGEJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 00:09:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:62308 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXHGEJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 00:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=T2AOC+t7xe90A6Xglo3W6VRf5zsPOpfHhHLZxppE6ICFDB3dgJc3w8tTE33JTC05evmbN8y7tJBqvvxHOu8d+BthazVedunYn2Y0iDiD3SgEU5gCE4gLqsUXi+3Zf9AhGvpNUNL1n2jZmE2/KEz54EqCAIbLAWrw8V6cuCu+wi8=
Message-ID: <46B7F059.3030403@gmail.com>
Date: Tue, 07 Aug 2007 13:08:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, akpm@osdl.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Off-by-one in /sys/module/*/refcnt
References: <20070805134923.GA5918@martell.zuzino.mipt.ru> <3ae72650708050700p1fc2959epcc1e9307e3c64fed@mail.gmail.com> <46B6B22C.1020609@gmail.com> <20070806194745.GB5842@martell.zuzino.mipt.ru>
In-Reply-To: <20070806194745.GB5842@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> sysfs internals were changed to not pin module in question.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
