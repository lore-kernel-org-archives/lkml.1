Return-Path: <linux-kernel-owner+w=401wt.eu-S936878AbXHMFvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936878AbXHMFvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 01:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbXHMFvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 01:51:17 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60001
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334AbXHMFvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 01:51:16 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Date: Mon, 13 Aug 2007 00:24:32 -0500
User-Agent: KMail/1.9.6
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200708120045.03032.jesper.juhl@gmail.com> <200708121611.02971.rob@landley.net> <46BF7FE5.7080004@s5r6.in-berlin.de>
In-Reply-To: <46BF7FE5.7080004@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130024.32832.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 4:47:17 pm Stefan Richter wrote:
> Rob Landley wrote:
> > On Sunday 12 August 2007 3:17:38 pm Stefan Richter wrote:
> >>   - it's a little bit faster to create these headers than to add them
> >>     to 00-INDEX:  Just move the existing title to the top.
>
> ...
>
> > What variant of "fast" do you mean?  Processing the entire directory
> > takes a fraction of a second on my laptop.
>
> I meant the speed of people, not the speed of text processors.

Gotcha.

Populating 00-INDEX from the first nonblank line of each file, skipping lines 
that are entirely punctuation, is a good suggestion.  A human has to go clean 
up the result, but I could do this thing... :)

Thanks for the suggestion.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
