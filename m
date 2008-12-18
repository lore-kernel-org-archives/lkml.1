Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752952AbYLRT06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbYLRT06 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYLRT0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:26:47 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:56369 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYLRT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:26:47 -0500
Date: Thu, 18 Dec 2008 11:26:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Helight.Xu" <helight.xu@gmail.com>, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH] fix some code style that line over 80 characters
Message-Id: <20081218112617.09fd97bd.randy.dunlap@oracle.com>
In-Reply-To: <20081210150116.GB21396@x200.localdomain>
References: <20081210135143.GB4595@helight>
	<20081210150116.GB21396@x200.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.494AA3DD.0041:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 18:01:16 +0300 Alexey Dobriyan wrote:

> On Wed, Dec 10, 2008 at 09:51:43PM +0800, Helight.Xu wrote:
> > -static inline struct s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> > +static inline struct
> > +s3c2410_platform_i2c *s3c24xx_i2c_get_platformdata(struct device *dev)
> 
> NAK!

OK, but please includes reason(s) for NAKs...

---
~Randy
