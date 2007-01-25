Return-Path: <linux-kernel-owner+w=401wt.eu-S1030527AbXAYTiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030527AbXAYTiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXAYTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:38:22 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60332
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030528AbXAYTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:38:21 -0500
From: Rob Landley <rob@landley.net>
To: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Date: Thu, 25 Jan 2007 14:38:02 -0500
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200701151624.18033.rob@landley.net> <200701251303.33607.rob@landley.net> <20070125191407.GA10853@flower.upol.cz>
In-Reply-To: <20070125191407.GA10853@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701251438.03213.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 January 2007 2:14 pm, Oleg Verych wrote:
> > I believe "shift 5" is also SUSv3. :)
> 
> If you have tested, please send ack or nack to us.

I have not.  I tested the one I sent.  Today I'm at a different location than 
that test environment.  All I can try it on here is Ubuntu, and so could you 
just as easily.

As I said, I'm not particularly interested in a more intrusive solution 
solving a problem I haven't actually seen.  I don't see any obvious reason 
why it wouldn't work, and yes it would probably also solve my problem, but I 
still don't see why you think it's "better" than the three byte fix.

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
