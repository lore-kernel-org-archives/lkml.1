Return-Path: <linux-kernel-owner+w=401wt.eu-S934479AbYBGVf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479AbYBGVf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759187AbYBGVfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:35:10 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:46496 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448AbYBGVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:35:07 -0500
Message-ID: <fa686aa40802071335l681cf0dfs97b8fe828427fa4a@mail.gmail.com>
Date: Thu, 7 Feb 2008 14:35:05 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: benh@kernel.crashing.org
Subject: Re: Xilinx: hwicap driver comments
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1202420016.7079.138.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB6552.7040503@gmail.com> <1202419066.7079.130.camel@pasglop>
	 <47AB7813.7050807@gmail.com> <1202420016.7079.138.camel@pasglop>
X-Google-Sender-Auth: dabf74e1e016876d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/08, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
> On Thu, 2008-02-07 at 22:28 +0100, Jiri Slaby wrote:
> > Yup, should... [I don't know how ofter people have 64bit resources on 32 bit
> > this becomes a problem.]
>
> For MMIO it's becoming more and more common actually in the embedded
> space. Xilinx uses 405 cores which I think still only have a 32 bits
> physical bus though, but if they ever extend it or switch to 440 they'll
> have a 36 bits bus.

The Virtex5 has a 440.  It's going to be released "real soon now"

g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
