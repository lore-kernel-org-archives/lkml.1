Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZJEVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZJEVbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZJEVbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:31:31 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55602
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZJEVba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:31:30 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Vladimir Dronnikov <dronnikov@gmail.com>
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
Date: Mon, 5 Oct 2009 16:30:50 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com>
In-Reply-To: <4aca1863.0a1ad00a.33bf.1017@mx.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910051630.51039.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009 11:01:39 Vladimir Dronnikov wrote:
> From: Vladimir Dronnikov <dronnikov@gmail.com>
>
> drivers/md/unroll.pl replaced by awk script to drop build-time dependency
> on perl
>
> Signed-off-by: Vladimir Dronnikov <dronnikov@gmail.com>

Acked-by: Rob Landley <rob@landley.net>

We already discussed this on another mailing list, thread starts at:

http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2009-October/000328.html

I've added this as patch #4 in the perl removal series I've submitted
during the last few merge windows.

Thanks,

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
