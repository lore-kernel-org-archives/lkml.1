Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXH2Og6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXH2Og6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXH2Ogw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:36:52 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:51940 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXH2Ogv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:36:51 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: speeding up swapoff
Date: Wed, 29 Aug 2007 16:36:46 +0200
User-Agent: KMail/1.9.6 (enterprise 20070731.694771)
Cc: Daniel Drake <ddrake@brontes3d.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <1188394172.22156.67.camel@localhost> <20070829073040.1ec35176@laptopd505.fenrus.org>
In-Reply-To: <20070829073040.1ec35176@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708291636.48323.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 29 August 2007 schrieb Arjan van de Ven:
> Another question, if this is during system shutdown, maybe that's a
> valid case for flushing most of the pagecache first (from userspace)
> since most of what's there won't be used again anyway. If that's enough
> to make this go faster...

Is there a good reason to swapoff during shutdown?

	Regards
		Oliver

