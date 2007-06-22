Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbXFVGP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbXFVGP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXFVGPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:15:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXFVGPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:15:52 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: davids@webmaster.com,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com>
	<or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622013417.GT21478@ftp.linux.org.uk>
	<or1wg4hawh.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622052315.GU21478@ftp.linux.org.uk>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 22 Jun 2007 03:15:23 -0300
In-Reply-To: <20070622052315.GU21478@ftp.linux.org.uk> (Al Viro's message of "Fri\, 22 Jun 2007 06\:23\:15 +0100")
Message-ID: <orzm2scy6c.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:

> On Fri, Jun 22, 2007 at 01:26:54AM -0300, Alexandre Oliva wrote:
>> No, this thread was about additional permissions to combine with other
>> licenses.  I didn't suggest anything about relicensing whatsoever,
>> that's all noise out of not understanding the suggestion.

> And that constitutes the change of license.

I stand corrected.  I misread what you wrote as "relicensing under
GPLv3, or GPLv2+".  Sorry.

> Suppose ZFS _is_ pulled into the tree via that mechanism.

Or even kept outside, such that third parties can create a combined
work and distribute that.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
