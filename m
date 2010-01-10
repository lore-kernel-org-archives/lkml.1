Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176Ab0AJHtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0AJHtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 02:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054Ab0AJHtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 02:49:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43720 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0AJHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 02:49:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dCa7LR4gQXREXnwqvsXDs4OwGy/mYcmSjV4jV/YkZvak3LJwn/y2fnUHGlCfWt2KW+
         UvGbB/TfqV2USj/xttSh2UfCohCLeP60vw3leVISHS/ySqi6Id3pTraQGWinBqEAQrDb
         EQkZtcBWQYCARmrDE/BBnT5oBPfXwAQRuptXw=
Date: Sat, 9 Jan 2010 23:49:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Raphael Derosso Pereira <raphaelpereira@gmail.com>,
       Kwangwoo Lee <kwlee@mtekvision.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jochen Eisinger <jochen@penguin-breeder.org>,
       linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] input: make i2c device id constant
Message-ID: <20100110074928.GB16057@core.coreip.homeip.net>
References: <4B487CD3.3080908@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B487CD3.3080908@freemail.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 01:55:47PM +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct i2c_driver is constant in <linux/i2c.h>
> so it is worth to make the initialization data also constant.
> 

Applied all 5 to the next branch, thank you Márton.

-- 
Dmitry
