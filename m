Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbXFYJbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbXFYJbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXFYJa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:30:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:14529 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXFYJa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:30:58 -0400
Date: Mon, 25 Jun 2007 11:30:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Robert Iakobashvili <coroberti@gmail.com>
cc: djones@rossove.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scaling Max IP address limitation
In-Reply-To: <7e63f56c0706250147w508d3aeay5f7aaca8215953c8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706251130320.11964@fbirervta.pbzchgretzou.qr>
References: <467EA7C1.4080006@rossove.com>  <20070624110236.fa36b2f9.akpm@linux-foundation.org>
  <7e63f56c0706241259u6e123ed6yc02b76f0260adaa5@mail.gmail.com> 
 <467F063A.2030805@rossove.com> <7e63f56c0706250147w508d3aeay5f7aaca8215953c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 25 2007 11:47, Robert Iakobashvili wrote:
>
> I am getting after initial successes some errors:
> "rtnl_talk(): RTNETLINK answers: Cannot allocate memory"
> and
> #ip addr | wc-l is 8194.

I'd be surprised if it was 4096 on x86 and 8192 on x86_64...


	Jan
-- 
