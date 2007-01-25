Return-Path: <linux-kernel-owner+w=401wt.eu-S964982AbXAYBA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbXAYBA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 20:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965007AbXAYBA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 20:00:29 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:7055 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964982AbXAYBA2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 20:00:28 -0500
Date: Thu, 25 Jan 2007 01:00:20 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Mark Rustad <mrustad@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.18-stable release plans?
Message-ID: <20070125010020.GB26654@deepthought>
References: <1C9991E6-04F3-493D-9236-D24E95BB609F@gmail.com> <559149.89346.qm@web52906.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <559149.89346.qm@web52906.mail.yahoo.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 11:45:57PM +0000, Chris Rankin wrote:
> 
> There is a world of difference between a polite request for more information (although I gave you
> everything I had), and fobbing someone off with a story about cosmic rays.
> 
 Chris,

 I doubt there was a single version of the kernel which ever worked
well for all its users.  In a production environment, reverting to an
older version may be the best short-term answer, but if nobody
recognises the problem you won't get any closer to a proper fix.  At
the moment, you have a problem that nobody recognises.  If you're not
willing to test if the problem happens repeatably, (you appear to
have had one failure and immediately reverted to an old kernel), who
do you think will be able to fix it?  And if it turns out it doesn't
fail repeatably, maybe the responses you've received could be
correct.

 The stable team are only there to maintain the current release of
the kernel.  There is no maintenance of earlier releases (except
Adrian's work on 2.6.16), other than what a distro chooses to do to
backport fixes.  Of course, if the problem _is_ reproducible on your
machine and config, you might get asked to try to identify when it
got introduced (e.g. was 2.6.19 itself, or an arbitrary 2.6.19-rc,
ok?).

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
