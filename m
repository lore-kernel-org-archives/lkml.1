Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXLLUbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXLLUbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXLLUbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:31:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:23114 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXLLUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:31:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=pFqFrO3TraoK/IRYBzs/qEPGIe9QJOOAP8nTA8Ylv+127s+1LhmsPwAU4IuuYXpN5xA8HlVthZLVFDx3//UUqXSgFpiCxZkluAsnLE+V4eEdSx2SRibn0VUXkSBLWSDyLpU/EQdZJiWLfIRZnTy0OlXkUGPSXFH1PlbbOVWn8YA=
Message-ID: <476044AC.40500@keyaccess.nl>
Date: Wed, 12 Dec 2007 21:29:32 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Chris Holvenstot <cholvenstot@comcast.net>
Subject: Re: [RESULTS] Port 0x80 I/O speed
References: <47603327.6070307@keyaccess.nl> <Pine.LNX.4.61.0712121459570.6100@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0712121459570.6100@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 21:18, linux-os (Dick Johnson) wrote:

> But there are some things that get set up long before
> udelay() is calibrated! The interrupt controllers,
> the timer, etc. You can't just substitute or you
> will end up with machines that won't boot!

We understand the problem. But it's not all that bad.

Rene.
