Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXHDTWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXHDTWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765615AbXHDTWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:22:10 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54021
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765544AbXHDTWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:22:08 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 1/2] Group architecture Documentation under Documentation/arch.
Date: Sat, 4 Aug 2007 15:22:03 -0400
User-Agent: KMail/1.9.6
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-doc@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Mundt" <lethal@linux-sh.org>
References: <200705222225.39949.rob@landley.net> <200708041404.01264.rob@landley.net> <9a8748490708041207t5ba8063s4a75eabc4c8db8b6@mail.gmail.com>
In-Reply-To: <9a8748490708041207t5ba8063s4a75eabc4c8db8b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041422.04493.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007 2:07:31 pm Jesper Juhl wrote:
> On 04/08/07, Rob Landley <rob@landley.net> wrote:
> > Signed-off-by: Rob Landley <rob@landley.net>
> > Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > Move architecture-specific Documentation into a common subdirectory.
>
> ...
>
> I have only one complaint; I don't see an update to Documentation/00-INDEX

I now have at least three.  (I missed blackfin, which wasn't there last time I 
did this.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
