Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbZFXTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbZFXTJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZFXTJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:09:28 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:29878 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752202AbZFXTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:09:28 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: [PATCH 00/13] revised Coldfire generic GPIO (mk68nommu)
Date: Wed, 24 Jun 2009 12:09:25 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       linux-m68k@vger.kernel.org
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com> <4A41C04F.6050909@snapgear.com>
In-Reply-To: <4A41C04F.6050909@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906241209.26199.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009 10:57:35 Greg Ungerer wrote:
> Hi Steven,
>
> This looks pretty good to me.
> Do you want me to apply the the m68knommu git tree?
> (Ideally I'll push it to Linus in the 2.6.32 merge window).

That would be great.  There are some things I'd like to add to this (support for 
pinmux, etc.) but that would be in the form of patches ontop of this.

-- 
Steven King -- sfking at fdwdc dot com
