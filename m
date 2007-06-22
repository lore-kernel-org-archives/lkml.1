Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbXFVEkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbXFVEkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXFVEk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:40:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbXFVEkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:40:25 -0400
To: Bron Gondwana <brong@fastmail.fm>
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com>
	<orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622013317.GG30132@brong.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 22 Jun 2007 01:40:18 -0300
In-Reply-To: <20070622013317.GG30132@brong.net> (Bron Gondwana's message of "Fri\, 22 Jun 2007 11\:33\:17 +1000")
Message-ID: <orsl8kfvpp.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, Bron Gondwana <brong@fastmail.fm> wrote:

> Great, so for ever and ever afterwards the code would have to keep a
> clear separation between the bits that are under different licences and
> make sure that no re-factor ever blurred the lines between them enough
> that you had trouble telling which was which.

As long as you care about being able to tell which is which, yes.  I
can understand why, under some circumstances, this might be taken as
worse than not being able to use code under GPLv3 (or any other
incompatible license) at all.

> understand what licence the final work is under.

If it's a mingled combination of code under GPLv2 plus permission to
combine with v3, and GPLv3 plus (potential built-in?) permission to
combine with v2, these are the combined terms.  You can still use it
with code under GPLv2 plus permission to combine with v3, and with
GPLv3 plus (potential built-in?) permission to combine with v2.  I can
see that it boggles the minds not used to this kind of combination.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
