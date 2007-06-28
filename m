Return-Path: <linux-kernel-owner+w=401wt.eu-S1762053AbXF1E71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762053AbXF1E71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 00:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbXF1E7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 00:59:10 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:60589 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753171AbXF1E7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 00:59:08 -0400
To: davids@webmaster.com
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKEELNEOAC.davids@webmaster.com>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Thu, 28 Jun 2007 01:57:18 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEELNEOAC.davids@webmaster.com> (David Schwartz's message of "Wed\, 27 Jun 2007 20\:44\:21 -0700")
Message-ID: <orwsxoy8up.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 28, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> Until someplace you can't actually access the software is customarily used
> for software interchange, ...

As in TiVo boxes? :-) :-)

> This is a defect in the GPL. At least as I understood it, the intent
> was to force distributors to remove any code for which there was a
> patent claim that might threaten redistribution. Section 7 fails to
> do that.

It's not intended to do that.  The existence of a patent doesn't
render the Software non-Free.  The patent holder's threats or
willingness to enforce it doesn't render the Software non-Free.  It's
accepting a restrictive license, voluntarily or by means of a court
order, that does.  And the GPL is not about anything but doing as much
as a copyright license can do to make sure the covered Free Software
remains Free for all its users.  So, requesting licensees to not use
their patents to deny other users' freedoms is something a copyright
license can do.  But since it can't affect patent holders that are not
copyright licensees, or any other legal mechanisms that non-licensees
could use to restrict users' freedoms, it remains silent about this,
rather than forcing licensees to comply with laws or avoid risks that
might not even apply to themselves.

> While you are granted rights under copyright, section 7 does not prevent
> people from using other laws (so long as they don't impose the restrictions
> or agree to them) to hamer your right to redistribute (or for those who
> receive a distribution from you to lawfully use the work).

I think that's correct, and IMHO that's how it's intended to be.

> It is quite difficult to actually arrange this. You would need something
> like a third party to indemnify your customers without your having to agree
> to such indemnification.

... and without making you a party in this collusion.  Basically, if
you're involved in the process of denying users' freedoms, the GPL may
have teeth for you.  If you're not, and you're not a licensee of code
present in that software, there's no way the GPL can stop you from
imposing whatever restrictions that law permits you to impose, if you
choose to do so.  But the GPL won't impose restrictions on others just
in case their downstream users might become your next target.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
