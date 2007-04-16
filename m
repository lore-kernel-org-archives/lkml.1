Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbXDPBEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbXDPBEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 21:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbXDPBEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 21:04:13 -0400
Received: from holomorphy.com ([66.93.40.71]:47657 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbXDPBEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 21:04:13 -0400
Date: Sun, 15 Apr 2007 18:04:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Maxim Uvarov <muvarov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       davidsen@tmr.com, randy.dunlap@oracle.com, dada1@cosmosbay.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
Message-ID: <20070416010424.GG2986@holomorphy.com>
References: <461A4C1E.3070309@ru.mvista.com> <20070415094706.GB10097@ucw.cz> <20070415102157.GB2986@holomorphy.com> <20070415201024.GB12012@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415201024.GB12012@ucw.cz>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-04-15 03:21:57, William Lee Irwin III wrote:
>> nvcsw and nivcsw are conventional variable names for these quantities.

On Sun, Apr 15, 2007 at 08:10:24PM +0000, Pavel Machek wrote:
> I can't decipher them and would not want users see them in /proc.
> Would nonvoluntary_ctxt_switch be that much worse?

I'm not too attached to a particular name. I just think that the
traditional counter names should pass readability/etc. criteria on
account of the very strong historical precedent. I'd consider more
verbose affairs for the sake of putative legibility as equivalent
in quality. Maybe that means others voting for the more verbose
names should result in an aggregate decision in favor of verbosity.


-- wli
