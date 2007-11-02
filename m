Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXKBGpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXKBGpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 02:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXKBGpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 02:45:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:52920 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbXKBGpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 02:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dBSXZeR1ouFneNmbrfZIqhWKo6vhxEkwiVKHERL/KvNPldpQ7WqHlJXj/Cg/GaFZoYREwUH0xK4o+qqwO5OiVtfovwWx2UZDw9Xd0+9tuugXzShtUB056z8Q2MV4Db216jCtLAqycIh90ZvG58TWelbikW9DP4k5xuEJfoHbZLM=
Message-ID: <344eb09a0711012345p1d6bd667s52ef38f3185b478@mail.gmail.com>
Date: Fri, 2 Nov 2007 12:15:41 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: [PATCH 6/7] d_path: Make d_path() use a struct path
Cc: "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       "Christoph Hellwig" <hch@lst.de>,
       "Andreas Gruenbacher" <agruen@suse.de>
In-Reply-To: <20071029124121.829255433@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029124120.528997881@weierstrass.suse.de>
	 <20071029124121.829255433@weierstrass.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Jan Blunck <jblunck@suse.de> wrote:
>
>

Did you miss the d_path() caller arch/blackfin/kernel/traps.c:printk_address() ?

Regards,
Bharata.
-- 
"Men come and go but mountains remain" -- Ruskin Bond.
