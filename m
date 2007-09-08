Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXIHN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXIHN7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 09:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXIHN7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 09:59:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:48082 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXIHN7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 09:59:12 -0400
Message-ID: <a0738740709080659m34a78f2em7280facb64577a88@mail.gmail.com>
Date: Sat, 8 Sep 2007 14:59:10 +0100
From: "Alex Smith" <lkml@alex-smith.me.uk>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Oops in pwc v4l driver
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0709021647m7ad694d7mf876bf4a6c8b4aca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a0738740709020457n3490ee52l49d29712f3ddbb75@mail.gmail.com>
	 <6bffcb0e0709021647m7ad694d7mf876bf4a6c8b4aca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2007, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi Alex,
>
> On 02/09/07, Alex Smith <lkml@alex-smith.me.uk> wrote:
> > Hi,
> >
> > I found an old Philips Askey VC010 webcam and attempted to get it
> > working on Linux (latest git, x86_64).
>
> Is this a regression? Does 2.6.22 work fine?

Not sure, I haven't tested with .22. But that patch definitely fixes
the issue - I can't cause it no matter what I do.

Thanks,
Alex

(P.S. Sorry for the late reply - I don't check my lkml email that often)
-- 
Alex Smith - http://www.alex-smith.me.uk
