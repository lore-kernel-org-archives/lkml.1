Return-Path: <linux-kernel-owner+w=401wt.eu-S965155AbZLGXMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbZLGXMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 18:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935707AbZLGXML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 18:12:11 -0500
Received: from mx2.netapp.com ([216.240.18.37]:4535 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935670AbZLGXMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 18:12:10 -0500
X-IronPort-AV: E=Sophos;i="4.47,357,1257148800"; 
   d="scan'208";a="284993501"
Subject: Re: [PATCH] SUNRPC: IS_ERR/PTR_ERR confusion
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Roel Kluin <roel.kluin@gmail.com>
In-Reply-To: <20091207230726.GA4685@fieldses.org>
References: <4B1CE844.1040108@gmail.com>
	 <20091207152654.GA29416@fieldses.org> <1260227059.2951.13.camel@localhost>
	 <20091207230726.GA4685@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Mon, 07 Dec 2009 18:12:15 -0500
Message-Id: <1260227535.2951.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
X-OriginalArrivalTime: 07 Dec 2009 23:12:16.0833 (UTC) FILETIME=[B7EF6310:01CA7792]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 18:07 -0500, J. Bruce Fields wrote: 
> On Mon, Dec 07, 2009 at 06:04:19PM -0500, Trond Myklebust wrote:
> > Are you planning on shepherding this fix into mainline, or should I?
> 
> I don't care, but I think of that as client-side code, so I'm assuming
> you're taking it.


OK. Will do...
