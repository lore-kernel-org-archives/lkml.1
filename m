Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbYBWVng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbYBWVng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYBWVn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:43:26 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47566
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbYBWVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:43:25 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Samuel Masham" <samuel.masham@gmail.com>
Subject: Re: 2.6.24 panics initializing ne2k in mips.
Date: Sat, 23 Feb 2008 15:43:22 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ralf Baechle" <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       linux-mips@vger.kernel.org
References: <200801280217.38273.rob@landley.net> <200802221619.40103.rob@landley.net> <93564eb70802222356u261d452aq8a3ad6ccc146d8dc@mail.gmail.com>
In-Reply-To: <93564eb70802222356u261d452aq8a3ad6ccc146d8dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802231543.22810.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 01:56:42 Samuel Masham wrote:
> On Sat, Feb 23, 2008 at 7:19 AM, Rob Landley <rob@landley.net> wrote:
> >  The patches that fixed it for me were:
> >
> >  http://kernel.org/hg/index.cgi/linux-2.6/rev/85295
> >  http://kernel.org/hg/index.cgi/linux-2.6/rev/85296
> >
> >  Which, as you can see, were already committed to the kernel repository
> > during the 2.6.25 merge window.
...
> This fixes the 2.6.24 kernel for qemu, I would like to see these
> patches put into the stable series.
>
> Is that OK for everyone? if they are in the 2.6.25 tree then we just
> send the commit ids to the stable team...

Sounds good to me:

24649c00ca334955ac7d8a79f5a7834fc7ea441d
46f4f8f665080900e865392f4b3593be463bf0d8

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
