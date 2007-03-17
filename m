Return-Path: <linux-kernel-owner+w=401wt.eu-S966005AbXCQBQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966005AbXCQBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 21:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966009AbXCQBQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 21:16:26 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:3104 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966005AbXCQBQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 21:16:25 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA problems in 2.6.20.3
Date: Sat, 17 Mar 2007 01:16:18 +0000
User-Agent: KMail/1.9.5
Cc: Charles Shannon Hendrix <shannon@widomaker.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fa.lqWgqhKIlhgG3TXcvhBc/T7bPFE@ifi.uio.no> <45FB2BD9.2070803@shaw.ca>
In-Reply-To: <45FB2BD9.2070803@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170116.18177.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 23:44, you wrote:
> Charles Shannon Hendrix wrote:
> > I normally run a modified 2.6.19 kernel and it works great.
> >
> > I recently tried 2.6.20 and had severe SATA problems with it.
> >
> > Yesterday I tried 2.6.20.3, and the problems are still there.
>
> Can you try 2.6.21-rc and see if the problem is fixed in those kernels?

-rc4 specifically, it's the first one that's worked for me (possibly related).

(BTW Robert, the sata_nv shadow registers patch has been fine here with a 
patched -rc3 for just over a week now.)

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
