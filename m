Return-Path: <linux-kernel-owner+w=401wt.eu-S935173AbZLPSmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173AbZLPSmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762817AbZLPSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:41:55 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:40295 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935159AbZLPSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:38:25 -0500
Date: Wed, 16 Dec 2009 19:38:23 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: perf and libdwarf on debian
Message-ID: <20091216183822.GA18410@boogie.lpds.sztaki.hu>
References: <20091216135448.GD11618@aftab>
 <1260988340.21028.198.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260988340.21028.198.camel@laptop>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:32:20PM +0100, Peter Zijlstra wrote:

> Then again, its not like debian would ever ship something recent enough
> to actually build perf with, even my karmic machine comes with
> libdwarf-20080409 which to me reads like ancient and not befitting a
> distro released a month or so ago.

"karmic" sounds Ubuntu, not Debian. In Debian:

$ apt-cache policy libdwarf-dev
libdwarf-dev:
  Installed: (none)
  Candidate: 20091012-1
  Version table:
     20091012-1 0
        990 http://ftp.hu.debian.org sid/main Packages
        500 http://ftp.hu.debian.org squeeze/main Packages
     20080409-2 0
        500 http://ftp.hu.debian.org lenny/main Packages

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
