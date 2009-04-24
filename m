Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbZDXJ0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbZDXJ0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZDXJ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:26:31 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:58173 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZDXJ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:26:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jCgIBGToW1KpZA0rVVtBQZgx6fsUwSnLAYYwu4PVnGIpis2lAyd4Q2vDoTEChOnnUt
         wnjaBwX+pJeYMkC6EI2i1x6DDs9Xmf8WaSHHqEGtUJim/4qC8EBO95kqg6bamjpAHU1u
         QOXjZya/d928fggftE2kdkOaOaUod9sHkC1BM=
MIME-Version: 1.0
In-Reply-To: <5da0588e0904131644g131dc816r61884e83bc4cd006@mail.gmail.com>
References: <alpine.LFD.2.00.0904130145050.4396@centaur.acm.jhu.edu>
	 <20090412235010.c8e3475b.akpm@linux-foundation.org>
	 <1239650202.16771.15.camel@heimdal.trondhjem.org>
	 <5da0588e0904131506k5c58e8ddob9bf38f61da6302a@mail.gmail.com>
	 <5da0588e0904131644g131dc816r61884e83bc4cd006@mail.gmail.com>
Date: Fri, 24 Apr 2009 05:26:28 -0400
Message-ID: <5da0588e0904240226j3454941y5f58c17a32a9a23d@mail.gmail.com>
Subject: Re: NFS BUG_ON in nfs_do_writepage
From: Rince <rincebrain@gmail.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied try 3 of Nick Piggin's patch to 2.6.30-rc3 (cleanly, no less!)

Doesn't appear to have helped at all - I received my favorite BUG ON
write.c:252 just like always, within 24 hours of booting the kernel,
even.

- Rich
-- 

Keep out of reach of children.
