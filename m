Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYJPWmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYJPWmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYJPWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:42:22 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:46249 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939AbYJPWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:42:21 -0400
Date: Fri, 17 Oct 2008 00:53:15 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: jeffschroeder@computer.org
cc: Bodo Eggert <7eggert@gmx.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use tmpfs for rootfs v2
In-Reply-To: <c24352ca0810161403r1842185bg2f8b4f8c067af541@mail.gmail.com>
Message-ID: <alpine.LSU.0.999.0810170047350.14480@be1.lrz>
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz> 
 <Pine.LNX.4.64.0810161507130.25933@anakin>  <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
 <c24352ca0810161403r1842185bg2f8b4f8c067af541@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Jeff Schroeder wrote:


> Haven't gotten the hang of attaching patches inline using gmail yet.
> Here is a patch ontop of the previous one that fixes whitespace problems
> pointed out by checkpatch.pl. It is based on 2.7.27
> 3fa8749e584b55f1180411ab1b51117190bac1e5
> 
> It is also available here:
> http://www.digitalprognosis.com/opensource/patches/linux-2.6/0001-Cleanup-the-whitespace-to-be-checkpatch-compliant.patch

Thanks. I'll update the patch soon.

Things you should know: In foo.rej, there are extra spaces. Some fools will 
keep them while applying these hunks.-(

-- 
"A slipping gear could let your M203 grenade launcher fire when you
least expect it. That would make you quite unpopular in what's left of
your unit."
-Army's magazine of preventive maintenance.
