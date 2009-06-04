Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZFDKkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZFDKkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZFDKj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:39:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:14820 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZFDKj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=soCiM3SnAotFRuvH/0I5qPW4DelfeoX/ivjjL7IvPWjOpQIh1r4Sfw1wVz4257t48w
         2fHgFdv/RNFSozZ+tDL4VjE90x1hRkZ5OeNpzxtdC7g2NBoGN5LdkNgfCKyzmJrwOPpL
         t7RfvFhXIFtkqqLoR3a6lQUCC0Ko1KbhzVJ7E=
MIME-Version: 1.0
In-Reply-To: <20090604020624.4d39e0a3.akpm@linux-foundation.org>
References: <4A278C08.5000206@samsung.com>
	 <20090604020624.4d39e0a3.akpm@linux-foundation.org>
Date: Thu, 4 Jun 2009 19:39:59 +0900
Message-ID: <1f3430fb0906040339j50e02e1w347b0fec05320cda@mail.gmail.com>
Subject: Re: [PATCH v2] add MAX17040 Fuel Gauge driver
From: Minkyu Kang <promsoft@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Wouldn't it be better to start the delayed_work after the
> power_supply_register() has succeeded?
>

Yes, that's better. thanks :)

-- 
from. prom.
promsoft.net
