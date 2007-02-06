Return-Path: <linux-kernel-owner+w=401wt.eu-S965421AbXBFBEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965421AbXBFBEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXBFBEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:04:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:6183 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965420AbXBFBEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LzC+5v2WKGnLJRNQCrlqE22DZPPTP2SuA6/L8UjQUEH4D72Q6Mcvd69YJ9qaM6xXmsZbFCIorluMSwPja0yuTiSt9FsHYuoNQvHTXq1X4FJ9C86MFUyqP9z4Qly+yK3A2EJS4t2oMkr/y9dVv+CUBLnD26pRny4YESitarwzwL8=
Message-ID: <e6babb600702051704s31cf24a5x425c9595b2266fdf@mail.gmail.com>
Date: Mon, 5 Feb 2007 18:04:08 -0700
From: "Robert Crocombe" <rcrocomb@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: ohci1394 broke 2.6.19 -> 2.6.20-rc1
Cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <tkrat.f2510ec744e6b5c8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e6babb600702051521l4a08eb2dw2a7f423fd0d7edd7@mail.gmail.com>
	 <tkrat.c39467d7194502c4@s5r6.in-berlin.de>
	 <tkrat.f2510ec744e6b5c8@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> It's my oversight, see patch.

Yes, this fixes things.  Thanks!

-- 
Robert Crocombe
