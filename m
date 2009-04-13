Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZDMXoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZDMXoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZDMXo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:44:29 -0400
Received: from mail-qy0-f117.google.com ([209.85.221.117]:65087 "EHLO
	mail-qy0-f117.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZDMXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:44:28 -0400
X-Greylist: delayed 5906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 19:44:27 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gd6OyWYYkonFXIjqy9LQtcb+PnD4pyeKrfP0bvvZ8fuzbpTGN0aYCVTdy1/GIOGsMU
         mRRgpJG77ND6Q9qn/8us+rkp7aiiSdPLxVxNoFVaMZc6AwU46SbGx1PTljexUAvd1qyF
         k+S9Dgj1R9TE9RveY6gmDAcYhN9NgQFhcNINA=
MIME-Version: 1.0
In-Reply-To: <5da0588e0904131506k5c58e8ddob9bf38f61da6302a@mail.gmail.com>
References: <alpine.LFD.2.00.0904130145050.4396@centaur.acm.jhu.edu>
	 <20090412235010.c8e3475b.akpm@linux-foundation.org>
	 <1239650202.16771.15.camel@heimdal.trondhjem.org>
	 <5da0588e0904131506k5c58e8ddob9bf38f61da6302a@mail.gmail.com>
Date: Mon, 13 Apr 2009 19:44:26 -0400
Message-ID: <5da0588e0904131644g131dc816r61884e83bc4cd006@mail.gmail.com>
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

On Mon, Apr 13, 2009 at 6:06 PM, Rince <rincebrain@gmail.com> wrote:
> Patch does not apply cleanly to 2.6.30-rc1. Working on this.

Okay, so I'm having trouble getting this to apply to anything at all.
I can see it requires a previous patch by Nick, but even in the thread
it's mentioned that it doesn't apply cleanly.

Is there a canonical form that I can apply somewhere?

- Rich

PS: I rather expect my report here to be the same as that Bugzilla
bug, since I filed it. :)
-- 

If we were meant to get up early, God would have created us with alarm clocks.
