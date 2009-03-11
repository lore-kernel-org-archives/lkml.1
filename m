Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZCKRk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZCKRk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZCKRks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:40:48 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:6739 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbZCKRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:40:47 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Woody Suwalski <woodys@xandros.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <49B7EEEA.3080203@zytor.com>
References: <49B703D4.1000008@zytor.com> <49B7C729.5080301@xandros.com>
	 <49B7EEEA.3080203@zytor.com>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 17:39:36 +0000
Message-Id: <1236793176.12283.255.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: x86: removing zImage support?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=N_8rpMpOnhAA:10 a=xy-wTJt7gRty3ge4HoEA:9 a=tmD6XrjbwDLlIyb-w7tjinn_x5MA:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 10:03 -0700, H. Peter Anvin wrote:
> Woody Suwalski wrote:
> >>   
> > If x86-only - OK.
> > 
> > However zImage is the format used on ARM quite often... So any "kernel
> > complexity removal" need to happen only on x86 side.
> > 
> 
> I have no idea about ARM zImage... the whole zImage vs bzImage is pretty
> x86-specific in the first place, so yes, I was referring to x86
> specifically.

Is there any point in just making bzImage==zImage for x86?

I lost count of the number of times I've explained that bzImage has
nothing to do with bzip...

Ian.

-- 
Ian Campbell
Current Noise: Alice In Chains - Nutshell

Live free or die.

