Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZLYKIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZLYKIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 05:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZLYKIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 05:08:13 -0500
Received: from ironport1.lbl.gov ([128.3.41.47]:46207 "EHLO ironport1.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbZLYKIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 05:08:13 -0500
X-Ironport-SBRS: 4.5
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmAAAJIdNEuAAykYkWdsb2JhbACbWwEBAQEJCwoHEwW5eYQzBA
X-IronPort-AV: E=Sophos;i="4.47,453,1257148800"; 
   d="scan'208";a="126162675"
Date: Fri, 25 Dec 2009 02:08:11 -0800 (PST)
From: Andrei Gaponenko <andrei.gaponenko@cern.ch>
To: Dave Airlie <airlied@gmail.com>
cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: drm/radeon/kms regression: 2.6.33-rc2 does not boot
In-Reply-To: <21d7e9970912250146s3e36cb9vcfc12a42445b37a2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912250204220.11466@x200s>
References: <alpine.LFD.2.00.0912250124410.11466@x200s> <21d7e9970912250146s3e36cb9vcfc12a42445b37a2@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1627421297-1261735692=:11466"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1627421297-1261735692=:11466
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 25 Dec 2009, Dave Airlie wrote:

> On Fri, Dec 25, 2009 at 7:31 PM, Andrei Gaponenko
> <andrei.gaponenko@cern.ch> wrote:
> > Hello,
> >
> > One of my systems works fine with 2.6.32, but hangs when trying to
> > boot 2.6.33-rc2.  Git bisect says
> > 7923c615b811945a9d9f456c92a7a32c34167458 is the first bad commit:
> > [...]
> 
> Can you wait for a minute or so and see if it continues? though this sounds like
> something different than others have seen.

I did let it to sit for many minutes during some of iterations of the
bisection; did not notice any progress.

Andrei

Please Cc me directly on replies.
--0-1627421297-1261735692=:11466--
