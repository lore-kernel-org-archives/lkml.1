Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbYESXG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbYESXG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbYESXGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:06:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:59745 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761679AbYESXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nYveNgmnS67/r+X/JfquCgBDtz4lZ0MkY+xtklWBKmBwIC+hJeGeqeifOnKLRR+i4yw/ixiE+roo0YH0J50nnNWyhE5/Lw+oaWaliFqgsa5F1SZpLyJe5e/i0+Nk/QWg4iFhpRgdfZkR4+67UuOiA7PsvMssNIbjznt/GlY1/bs=
Subject: Re: [2.6.27 patch] the scheduled smbfs removal
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steven French <sfrench@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <OF86D6B4D3.18C3673E-ON8725744E.007E5B54-8625744E.007EBB19@us.ibm.com>
References: <OF86D6B4D3.18C3673E-ON8725744E.007E5B54-8625744E.007EBB19@us.ibm.com>
Content-Type: text/plain
Date: Mon, 19 May 2008 16:06:10 -0700
Message-Id: <1211238370.5915.96.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 18:03 -0500, Steven French wrote:
> FYI - last week at connectathon I added one patch relating to backlevel 
> support and mapping of open flags on legacy smb open calls (although 
> perhaps some longtime smbfs users would not notice since smbfs did not 
> have this support either).
> 
> The utimes support for backlevel servers is one obvious thing that I have 
> not added (but smbfs had some limited support for) but was considring 
> adding.
> 

Just curious if there was a shortlist somewhere of anything supported in
smbfs but not in cifs?

Harvey

