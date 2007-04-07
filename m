Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXDGP2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXDGP2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 11:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbXDGP2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 11:28:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48484 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbXDGP2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 11:28:04 -0400
Message-Id: <1175959684.29481.1183471808@webmail.messagingengine.com>
X-Sasl-Enc: oZMRPPV5+55czSV9N6snFrqNRmf1mw9uzbkn+8m80YRg 1175959684
From: johnrobertbanks@fastmail.fm
To: "Dale Amon" <amon@vnl.com>
Cc: "Jan Harkes" <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20070407125914.GA31074@vnl.com>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: <20070407125914.GA31074@vnl.com>
Date: Sat, 07 Apr 2007 08:28:04 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 13:59:14 +0100, "Dale Amon" <amon@vnl.com> said:
> Jan does have a point about bad blocks. A couple years ago
> I had a relatively new disk start to go bad on random blocks.
> I detected it fairly quickly but did have some data loss.
> 
> All the compressed archives which were hit were near
> total losses; most other files were at least partially
> recoverable.

As you know, there is not substitute for backups. What if the disk had
totally crashed and scratched GBs of your data.

And did you ever trust those (non-compressed) executables that you saved
after recovering them from corruption?

Of course not. No one would. The fact that they were not compressed did
not save them.

You are really arguing for backups, not for one filesystem or another.

Besides, Jan claimed that corruption due to bad blocks propagates to
MULTIPLE files because of the compression in the file system. You are
arguing something different.

> It is not a matter of your operating system writing
> to bad blocks. It is a matter of what happens when the
> blocks on which your data sit go bad underneath you.
>
> This issue has also been discussed by people working
> with revision control system. If you are archiving
> data, how do you know you if your data is still good
> unless you actually need it? If you do not know it
> is bad, you may well get rid of good copies thinking
> you do not need the extras... it does happen.
> 
> I would be quite hesitant to go with on disk compression
> unless damage was limited to only the bad bits or blocks
> and did not propagate through the rest of the file.

You don't really mean that. Most backup uses compression (which
propagates errors through the rest of the file).

> Perhaps if everyone used hardware RAID and the RAID
> automatically detected a difference due to trashed
> data on one disk and flagged the admin with a warning...
> 
> BTW: I'm a CMU Alum, so who are you working with John?

I retired quite young.
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - Send your email first class

