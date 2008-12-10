Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYLJO46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYLJO46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYLJO4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:56:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:51407 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYLJO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:56:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r9NyBxRAEUPHvgOdQj2absqROMYh2u74reGNtwbEZOR51grO9Y6fNoEZGTB/vTHKIR
         bCy/c1fYczdof6a79i8QhP50Dqxv7MyMWKYMee4cGRztuC6yFJeWnKwwcOmSf287gGS0
         /9H84op0Q9lVAQFMjiUALLOk1/J2UvUM4kejM=
Date: Wed, 10 Dec 2008 18:01:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH] fix some code style that line over 80 characters
Message-ID: <20081210150116.GB21396@x200.localdomain>
References: <20081210135143.GB4595@helight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210135143.GB4595@helight>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 09:51:43PM +0800, Helight.Xu wrote:
> -static inline struct s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> +static inline struct
> +s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)

NAK!
