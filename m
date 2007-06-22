Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbXFVE2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbXFVE2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXFVE16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:27:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbXFVE15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:27:57 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: davids@webmaster.com,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com>
	<or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622013417.GT21478@ftp.linux.org.uk>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 22 Jun 2007 01:26:54 -0300
In-Reply-To: <20070622013417.GT21478@ftp.linux.org.uk> (Al Viro's message of "Fri\, 22 Jun 2007 02\:34\:17 +0100")
Message-ID: <or1wg4hawh.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 21, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:

> On Thu, Jun 21, 2007 at 10:00:22PM -0300, Alexandre Oliva wrote:
>> Do you agree that if there's any single contributor who thinks it
>> can't be tivoized, and he manages his opinion to prevail in court
>> against a copyright holder, then it can't?  That this is the same
>> privilege to veto additional permissions that Al Viro has just
>> claimed?

> You know, I'm rapidly losing any respect for your integrity.  The only
> "privelege" claimed is that of not relicensing one's contributions.

No, this thread was about additional permissions to combine with other
licenses.  I didn't suggest anything about relicensing whatsoever,
that's all noise out of not understanding the suggestion.

You objected to granting additional permissions.  You have that right,
per copyright law, and the other developers can then decide between
not granting an additional permission or removing all the code you
contributed such that they can.  That's veto.

Similarly, if someone proposed an additional unambiguous permission to
tivoize under GPLv2, any developer who objected to it could veto it
(the alternative being to remove all of his contributions).

> What really gets me is that you know it.

Yes.  The only disagreement is that I'm talking "additional permission
to combine" and you seem to keep understanding "relicensing", even
though these are very different concepts, with significantly different
consequences.

What they have in common is that you can veto either one with your
status as copyright holder, and that they would both permit some forms
of cooperation.

Permission to relicense would provide for one-way cooperation out of
Linux.  I'm not proposing this.  That would be stupid.  You've already
decided about it.  I respect that decision.  I even understand why you
made that decision.

Relicensing would provide for two-way cooperation, but under terms
that you don't consider acceptable.  You've pretty much already
decided not to do it.  I respect that decision.  I even understand why
you made that decision.

Permission to combine in both sides would provide for two-way
cooperation in ways that enable each author to enforce the terms s/he
chose for his/her own contributions.  This would address many of the
concerns raised about relicensing, and would increase the amount of
contributions in kind you can get.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
