Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360Ab0ABCnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0ABCnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 21:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303Ab0ABCnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 21:43:12 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38525 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0ABCnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 21:43:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qHUp3sQK4w60CbpKVIKPFkhiX9sfD5QQ3vXufdZuq9srk4NuRtbZkIolGru9H4QxW/
         k1BZVOWGC50T4urAD/COtZav2Qt3NVjrKo4Ba5vl/CJbEedKm7StWfFDumZqgP3ulLrF
         n+h84c2mZMmsKdzQva7sYaw8Pg3+t4lg494As=
Date: Fri, 1 Jan 2010 18:43:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: &&/|| confusion in gf2k_connect()?
Message-ID: <20100102024305.GA5788@core.coreip.homeip.net>
References: <4B3C96DF.8060903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3C96DF.8060903@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 01:19:43PM +0100, Roel Kluin wrote:
> This always evaluates to true.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied to 'for-linus', thank you Roel.

-- 
Dmitry
