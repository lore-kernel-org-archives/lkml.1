Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZLBUeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZLBUeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZLBUeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:34:10 -0500
Received: from mx2.netapp.com ([216.240.18.37]:9195 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbZLBUd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:33:56 -0500
X-IronPort-AV: E=Sophos;i="4.47,330,1257148800"; 
   d="scan'208";a="282981550"
Subject: Re: [patch 0/4] nfs: cleanups in nfs_rename()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091202150454.616582634@szeredi.hu>
References: <20091202150454.616582634@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Wed, 02 Dec 2009 15:33:39 -0500
Message-Id: <1259786019.2663.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
X-OriginalArrivalTime: 02 Dec 2009 20:33:47.0433 (UTC) FILETIME=[BFD35990:01CA738E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 16:04 +0100, Miklos Szeredi wrote: 
> Hi Trond,
> 
> This small patchset cleans up accumulated cruft in nfs_rename().  It's
> been lightly tested.
> 
> Thanks,
> Miklos
> --

Thanks Miklos! I will apply.

Cheers
  Trond
