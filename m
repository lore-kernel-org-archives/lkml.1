Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbXDCENS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbXDCENS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 00:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXDCENS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 00:13:18 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:30580 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXDCENR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 00:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iuj0tSOyKgxt2iPHOCrZ5PAhwXdeh7LBK3nLKHnnS/+j4sKoPTSz3R/HbFQ3CnLT61rT4HYnFXdgt77vqYWvlCyApu3b2QTND/7L0PivrageFzjg8965AWJpxiXexjzd4JmufwjBdnoOdOMPG/7lTMaNsi57v1URudb1jC1jAYE=
Message-ID: <4611D457.5050309@gmail.com>
Date: Tue, 03 Apr 2007 13:13:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, jgarzik@pobox.com
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image
 Windows driver (v2)
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070331181940.GV14134@stusta.de> <4611D289.5090209@shaw.ca>
In-Reply-To: <4611D289.5090209@shaw.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This adds some NCQ blacklist entries taken from the Silicon Image 3124/3132
> Windows driver .inf files. There are some confirming reports of problems
> with these drives under Linux (for example
> http://lkml.org/lkml/2007/3/4/178)
> so let's disable NCQ on these drives.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
