Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbZCTATm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbZCTATm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbZCTATa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:19:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:14418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZCTAT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XBXs5a6/eIC8RBw2nioj0TiTUh4cefSnzaOqZzaAoNDbENU7GiGJMGEX0+RaJjoJxT
         ACMtvnZxvzwpeWu4tAuuV2ISNpxoLpPI3k8KyGdgqxKosJKcQIf35/6ONAEvhFjauqRh
         JaJ95t/XNtS2AqLdOon755ZywcaiHw0UyDzJ4=
MIME-Version: 1.0
In-Reply-To: <18882.57341.196519.507194@notabene.brown>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
	 <18882.57341.196519.507194@notabene.brown>
Date: Thu, 19 Mar 2009 17:19:27 -0700
X-Google-Sender-Auth: 100fea1519483d69
Message-ID: <e9c3a7c20903191719y501925f2w65c6959e964a9470@mail.gmail.com>
Subject: Re: [PATCH 09/13] iop-adma: P+Q self test
From: Dan Williams <dan.j.williams@intel.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 5:14 PM, Neil Brown <neilb@suse.de> wrote:
>> +#include <linux/raid/raid6.h>
>
> ???
>  <linux/raid/pq.h>  Maybe?
>

Yes, neglected the cross compile before pushing this out, will fix.

Thanks,
Dan
