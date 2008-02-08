Return-Path: <linux-kernel-owner+w=401wt.eu-S934523AbYBHUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523AbYBHUNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761438AbYBHUNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:07 -0500
Received: from ag-out-0708.google.com ([72.14.246.242]:4204 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761344AbYBHUNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=QXQoJOQlCRMVtJkvfyVIjIykkS5MMQftRxZjfHqjVqBHYjazmm/hh0a45il3eGei38/RlMzF54pR4QopiNvpQeogRJ6NLDNz0ZtPj+WO55KfXUUwp+aXnJ3EiAZS4jFyonVHC43VDwPwvjd9wvAxdd8C0eg0vziw6yrZwiDbZCQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] Introduce HAVE_IDE to support flexible IDE per arch configuration
Date: Fri, 8 Feb 2008 21:26:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>, linux-ide@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
References: <20080207214256.GA22572@uranus.ravnborg.org> <20080208200446.GB31984@uranus.ravnborg.org>
In-Reply-To: <20080208200446.GB31984@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802082126.55911.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 08 February 2008, Sam Ravnborg wrote:
> Hi Bartlomiej.
> 
> Do you have any opinion on this patch?

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> I can push it via kbuild.git if you prefer but not without an

Fine with me.

> acknowledge from you.

Thanks,
Bart
