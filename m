Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbYDCVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbYDCVvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYDCVuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:50:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:58461 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760848AbYDCVuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Soh6IDZSFQJrWwLcCJbj1OI2JtuVbqWwlhRuPkT7vwt03abK+QaTOPAmUBViFby9SB9vC9snz9CS7B3P66dfUa9t2Y7BaWI5FeSZ2Nl+Ia4TaAl5fYDhOrUewo4rHNQIUybEQ8Qih82eE+yLahggzZ9niqZur/AuCkoWP61CB5g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH 1/2] ide: remove /proc/ide/ali
Date: Fri, 4 Apr 2008 00:04:54 +0200
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, akpm@osdl.org, linux-kernel@vger.kernel.org
References: <200804022044.49434.adobriyan@sw.ru> <200804022120.28339.bzolnier@gmail.com> <200804031749.24095.adobriyan@sw.ru>
In-Reply-To: <200804031749.24095.adobriyan@sw.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804040004.54481.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008, Alexey Dobriyan wrote:
> On Wednesday 02 April 2008 23:20:28 Bartlomiej Zolnierkiewicz wrote:
> > Could you please re-do patch #1/2 to remove /proc/ide/ali instead?
> > 
> > [ like we did for all other /proc/ide/<host_driver> files ]
> 
> Oh, even better!
> 
> 
> [PATCH 1/2] ide: remove /proc/ide/ali
> 
> Bart says: "can be done from user-space and is not especially interesting
> even when debugging problems (raw PCI config space dump is far more useful)."
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>

thanks, applied
