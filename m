Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbXFVEOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbXFVEOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXFVEOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:14:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbXFVEOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:14:35 -0400
To: davids@webmaster.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com>
	<orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622005834.GD602@delft.aura.cs.cmu.edu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 22 Jun 2007 01:14:27 -0300
In-Reply-To: <20070622005834.GD602@delft.aura.cs.cmu.edu> (Jan Harkes's message of "Thu\, 21 Jun 2007 20\:58\:34 -0400")
Message-ID: <or645ghbh8.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> On Thu, Jun 21, 2007 at 08:23:57PM -0300, Alexandre Oliva wrote:
>> It's not like anyone can safely tivoize devices with GPLv2 already, 

> So you really didn't pay any attention to anything people told you?

Yes.  Particularly to what Alan Cox and his legal counsel told me.  A
single copyright holder able and willing to enforce the license
against tivoization is enough.  What part of this don't you
understand?

> The license does not grant the right that you will be able to run the
> software on any particular platform or whether it will even work at all.

It doesn't grant TiVo the right to distribute the program without
corresponding source code.

They fail to distribute the source code to the functional signature
derived from the kernel binary.

Kaboom!


As for the right to run the program, I've also explained why in
Brazilian copyright law this is a right granted by the license,
because the license says that right is unrestricted.

Kaboom!

> There is no need to take out contributions because the GPLv2 does
> not prevent tivoization.

Says you (or perhaps you're just repeating what you heard and want to
believe).

But what did your lawyer say about it?  In reference to which
jurisdiction?

> A mutual compatibility agreement (sublicense) would effectively
> terminate any rights granted by the GPLv2,

Additional permissions to combine are not permission to relicense.
Look at section 13 of GPLv3dd4 and of Affero GPLv3dd1.  That's the
sort of additional permission I'm talking about here.

The same kind of additional permission that GPLed projects that use
openssl adopt.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
