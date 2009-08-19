Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZHSHOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZHSHOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZHSHOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:14:06 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:33587 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZHSHOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XyiArGq2RufGQqjM0Ua6pY4YO4I1CEkrwd1HKyt8Ifr5pi/IA6GIiHhGxAjA/i4i+T
         P5OIo40A674GD5S4FpbWcDk7cqS48fD7k/py/XZJO8ZeP0AHL86rwtSHprp1TmsGNC2W
         RCxF4qCLZC8smnrGMJPEycW3kwnyOntIujSys=
MIME-Version: 1.0
In-Reply-To: <20090819154958.18a34aa5.minchan.kim@barrios-desktop>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	 <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
	 <4A8B7508.4040001@vflare.org>
	 <20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
	 <18eba5a10908182324x45261d06y83e0f042e9ee6b20@mail.gmail.com>
	 <20090819154958.18a34aa5.minchan.kim@barrios-desktop>
Date: Wed, 19 Aug 2009 16:14:05 +0900
Message-ID: <18eba5a10908190014q6f903399y30478b4c0a7f256b@mail.gmail.com>
Subject: Re: abnormal OOM killer message
From: Chungki woo <chungki.woo@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, ngupta@vflare.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You means your pages with 79M are swap out in compcache's reserved
> memory?

Compcache don't have reserved memory.
When it needs memory, and then allocate memory.

Thanks.
