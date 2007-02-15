Return-Path: <linux-kernel-owner+w=401wt.eu-S1161607AbXBOWpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161607AbXBOWpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161608AbXBOWpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:45:22 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:3367 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161607AbXBOWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JHeEALTLYQM6OU/GA5B2wVxXoWJnzhNxX5JNFJ47DHYMAthmf4ZFvkBKaFSkEaBQaumJZH0zxGmpy2QUQWVIMmevm6e6t8l2e/pFv/cZwaYkGuGi179KkWN8IxmKhLugFhO8GntAAOfT9KXe222yeCAKh4cuSAmR+yqGn29cIk4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm1
Date: Thu, 15 Feb 2007 23:51:07 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152351.07432.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 15 February 2007 14:14, Andrew Morton wrote:

> - The IDE tree got dropped due to various linkage problems

Doh, I guess this is what one gets for not testing modular
IDE driver support properly. :(

All linkage problems should be fixed now, sorry for that.

Bart
