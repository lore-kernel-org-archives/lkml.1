Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbZETLcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbZETLcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbZETL2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:28:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50564 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbZETL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:28:32 -0400
Date: Wed, 20 May 2009 13:34:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [x86] [MCE] Updated 32bit merge for tip x86 mce2 branch
Message-ID: <20090520113430.GD8684@one.firstfloor.org>
References: <20090519215631.GA15626@basil.nowhere.org> <4A13D045.6090905@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A13D045.6090905@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK.  Please use following patches with my Signed-off-by instead.
> And an another revert patch should be applied to tip tree too.

Thanks.

Ideally these patches should be just removed before upstreaming. But I didn't 
want to touch the original branch for now so it's clear what I changed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
