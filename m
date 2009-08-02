Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZHBXmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZHBXmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 19:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZHBXmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 19:42:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZHBXmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 19:42:01 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [ANNOUNCE] Reiserfs/kill-bkl tree v2
References: <20090731174642.GA6539@nowhere>
	<20090801081141.GA18036@basil.fritz.box>
	<20090801155335.GA4836@nowhere> <20090802142100.GA21160@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 02 Aug 2009 19:41:01 -0400
In-Reply-To: <20090802142100.GA21160@elte.hu> (Ingo Molnar's message of "Sun, 2 Aug 2009 16:21:00 +0200")
Message-ID: <y0mzlah238y.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

>> Yeah good idea. But again, I fear my laptop hasn't enough memory 
>> to support big enough ramdisks mount points to host selftests.
>
> Well, dont waste too much time on it (beyond the due diligence 
> level) - Andi forgot that the right way to stress-test patches is to 
> get through the review process and then through the integration 
> trees which have far more test exposure than any single contributor 
> can test.

What guideline can you offer as to what is "due diligence" level of
stress testing, as compared to delegating this task to eyeballed
reviews + incidental use on the integration trees?

- FChE
