Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYHMGFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYHMGFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYHMGFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:05:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347AbYHMGFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:05:24 -0400
Date: Tue, 12 Aug 2008 23:05:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: harvey.harrison@gmail.com, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/22] x86: use the new byteorder headers
Message-Id: <20080812230511.6182a084.akpm@linux-foundation.org>
In-Reply-To: <20080812.225924.62357936.davem@davemloft.net>
References: <1218587234.30194.93.camel@brick>
	<20080812225612.6742aaf0.akpm@linux-foundation.org>
	<20080812.225924.62357936.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 22:59:24 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 12 Aug 2008 22:56:12 -0700
> 
> > I'll drop them all.  Do you have a cross-compiler suite there?
> 
> I think Harvey needs a mentor which can help him learn how to properly
> build validate his patches before he submits them, and how to not mix
> things up by, for example, validating the build with patches applied
> that won't be submitted etc.
> 
> Every time I integrate these byteorder patches directly for networking
> or sparc, it tends to be a build regression nightmare.
> 
> I think Andrew has hit 3 already with this patch series, quite an
> accomplishment.  :-/

heh.  This is why I habitually wait until Harveypatches hit version 4. 
Maybe I need to increment that a bit.

