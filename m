Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZKRRae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZKRRae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757989AbZKRRad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:30:33 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63396 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924AbZKRRac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:30:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mVTlQ/i4FtwcVOx59/DJktoKZHqVv352SDtyH0m2zH4B0m7XL2O1O9nbk9QgEx6KJt
         n2wzn5A50YkBE7TIhj5mSmR9EwT7sMgsKa5z88n2O/Z3+oaKV3AEduMiQpQguNoUHvvn
         Tr7Wb0WJT5QzRsWgmuk1twe6Grs+KWb1M8Lhs=
Date: Wed, 18 Nov 2009 09:30:33 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] input: atmel_tsadcc: touchscreen rework setting
	capabilities
Message-ID: <20091118173033.GA4385@core.coreip.homeip.net>
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Wed, Nov 18, 2009 at 03:12:12PM +0100, Nicolas Ferre wrote:
> Tiny patch for setting capabilities using input API function.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

All looks good. Since the series span platform and input subtrees how do
you want to merge it?

-- 
Dmitry
