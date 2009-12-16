Return-Path: <linux-kernel-owner+w=401wt.eu-S935442AbZLPWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935442AbZLPWbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935246AbZLPWbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:31:45 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15727 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbZLPWbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:31:44 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8
 a=HHePs4sdYWm55w6rC0EA:9 a=wPNm1x4lOPhe_3MLUwUA:7
 a=xtDKKMtXRNqLNq4Z7fCvY7uliIgA:4 a=x8gzFH9gYPwA:10 a=sdOIwOD7nXcA:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: perf and libdwarf on debian
Date: Wed, 16 Dec 2009 15:31:41 -0700
User-Agent: KMail/1.12.4 (Linux/2.6.31-1-amd64; KDE/4.3.4; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Gabor Gombas <gombasg@sztaki.hu>,
       Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <20091216135448.GD11618@aftab> <20091216183822.GA18410@boogie.lpds.sztaki.hu> <1260989893.21028.238.camel@laptop>
In-Reply-To: <1260989893.21028.238.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912161531.41957.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed December 16 2009, Peter Zijlstra wrote:
> On Wed, 2009-12-16 at 19:38 +0100, Gabor Gombas wrote:
> > On Wed, Dec 16, 2009 at 07:32:20PM +0100, Peter Zijlstra wrote:
> > > Then again, its not like debian would ever ship something recent
> > > enough to actually build perf with, even my karmic machine comes with
> > > libdwarf-20080409 which to me reads like ancient and not befitting a
> > > distro released a month or so ago.
> >
> > "karmic" sounds Ubuntu, not Debian. In Debian:
> 
> And here I thought ubuntu was generally a less ancient debian..
> 

Only at the moment they mirrored the Sid repo for the new release. After 
that things freeze.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>  in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
