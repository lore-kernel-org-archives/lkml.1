Return-Path: <linux-kernel-owner+w=401wt.eu-S965119AbYEBRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119AbYEBRar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764022AbYEBRa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:30:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:58400 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934820AbYEBRaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U9UAmR1qO+XGp+waeTGKMuPR/EFSIKYvR7eAkqPxcA8DRNDOz5TdQiHEKPgmPxU/nGTUN0je9jic7XHKUpormsWERvs7QtyCFJDObelofz6aknpfs3X19eMhBZ/BP6NpkWg7NL2QQ4fNcFkDksDX3EBJH9xBpuOwPLtQZyY8MlI=
Message-ID: <82e4877d0805021030s793835a1le0032673b0f4c6c7@mail.gmail.com>
Date: Fri, 2 May 2008 13:30:23 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: How to reduce the number of open kernel bugs
Cc: "Adrian Bunk" <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805021229.47038.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
	 <200805021229.47038.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 12:29 PM, Daniel Hazelton <dhazelton@enter.net> wrote:
This is what Adrian was pointing
> ... out and is exactly what shouldn't be happening.
>

I wasn't arguing that it is what should be happening - I was just
pointing out that there are worse things than that routinely happen in
distro bugzillas!

Also I feel that if maintainer refuse to fix something - that's a dead
end as far as that particular bug is considered. We can try and track
such bugs in different STATUS but there would have to be people
interested in digging through such bugs and willing to fix it after
the maintainer has given up. Which is possible but not likely.

Parag
