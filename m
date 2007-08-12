Return-Path: <linux-kernel-owner+w=401wt.eu-S1761059AbXHLRLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059AbXHLRLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763095AbXHLRK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:10:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:22678 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761200AbXHLRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PXv0RfTPObN8ViTfkTXBLzuO359baJ+LzYAp+0f9apdVusUn7JYZfdGYb3h2lBR6lq2n2ySaIZb87uEwKpLTqGvWISMIuVHkzu25gEadU+vtQGku7yywNRjAiQ9Gh4AoGznvwCfJCvDibdmtzSrw38aQvTTTJ+k3R+nrkRlf3+w=
Message-ID: <9a8748490708121010q7fe3bfbx8d4d8b997ed5fc72@mail.gmail.com>
Date: Sun, 12 Aug 2007 19:10:56 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Cc: linux-doc@vger.kernel.org, "Rob Landley" <rob@landley.net>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46BF01A5.9060003@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708120045.03032.jesper.juhl@gmail.com>
	 <46BF01A5.9060003@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Jesper Juhl wrote:
> > Rob Landley is trying to organize Linux kernel documentation. One
> > thing he is doing is generating index.html files based on our
> > 00-INDEX files in the Documentation directory. He has met with a
> > small problem however, since not all subdirectories inside
> > Documentation contain such a file, nor are all the files that do
> > exist up to date, his index.html files turn up rather incomplete.
> [...]
> > I want to get some feedback before wasting too much time
> > creating these files
> [...]
>
> Isn't it with 00-INDEX just like with the "Last Updated:" footers in
> documentation texts?
>
That is certainly a risk, yes. But it shouldn't be hard to write a
small script to check if the 00-INDEX files are up-to-date, that will
make it pretty simple to update them once in a while if people forget.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
