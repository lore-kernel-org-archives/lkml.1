Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZG0FZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZG0FZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZG0FZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:25:15 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:49583 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZG0FZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PEh/s0NEClCPm6oPmw8ykzM0yeUmboEdpNiubzLtxZ8jt2pUYsgwlAsxjCG+Eujd2N
         qRugdDUzrOHgUnA2rJQwSZAzWO5ERVWPS2itF1YaUD30l9MZUjKXhG5VmHZAQW1fbT6V
         wkEDXVo3BH/OdlHJkMYBaHj3Vdlh5b+t+x/k4=
Date: Mon, 27 Jul 2009 13:27:22 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Boot panic in 2.6.31-rc4
Message-ID: <20090727052722.GA5877@cr0.nay.redhat.com>
References: <2375c9f90907262010s36980f88q28f10b6bc2b5263f@mail.gmail.com> <3877989d0907262100la342487j52cf5e12e5efe520@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0907262100la342487j52cf5e12e5efe520@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 12:00:33PM +0800, Luming Yu wrote:
>CONFIG_SYSFS_DEPRECATED_V2 disabled by default?
>


Yup, enabling it makes the panic disappear...

Thanks.

P.S. This is newly introduced?
