Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbYLWN3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbYLWN3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 08:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYLWN3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 08:29:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:50651 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYLWN33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 08:29:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tX4LmXlqH6Gq1JAVy8daeG8ykAxtqq7sx2vvxAdAQLqOKpNF/ZJ/Z6AVqTVpFsFsYK
         Ufih6eWDeEtT5DILnNFYfCe1WKAkbhuHPNEJZtgeOs3DKqy2j+Q/7HZkHsihY5QiamQ/
         cq8sFSSeJrgWKfOHQQjf0/m4gbaozinsyGoK0=
Message-ID: <961aa3350812230529y39b99c90ned87fe590b6b7afb@mail.gmail.com>
Date: Tue, 23 Dec 2008 22:29:27 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] failslab for SLUB
Cc: linux-kernel@vger.kernel.org,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0812231459580.18017@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081223103616.GA7217@localhost.localdomain>
	 <Pine.LNX.4.64.0812231459580.18017@melkki.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code duplication in your patch is unfortunate. What do you think of
> this patch instead?

Oh, looks good to me.
