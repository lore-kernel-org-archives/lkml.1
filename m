Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYKIQYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYKIQYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYKIQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:23:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:60595 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbYKIQXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:23:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Bou7eMWSngJys7ymFO7IlQXR7kTo0Xv2bKC1CDDqOOnsNTwhhM606PjSqv6r60IfmL
         FPuKGWDlHAldkfKx6ntkiy41XG0CcJ0xuN4otlpSl0nHw4sYfeZcRGbHhp1uxHhjHP8l
         9RN7jlbEYEo8m9uxsqvr6mF2AY7zYmDXHiR/U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: ide: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Sun, 9 Nov 2008 15:46:07 +0100
User-Agent: KMail/1.9.10
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1225330252.5970.89.camel@nga.site>
In-Reply-To: <1225330252.5970.89.camel@nga.site>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811091546.07737.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008, Kay Sievers wrote:

[...]

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: ide: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>

applied
