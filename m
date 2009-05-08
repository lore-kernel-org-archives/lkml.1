Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZEHEdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZEHEdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZEHEdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:33:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42485 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZEHEdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:33:21 -0400
Message-ID: <4A03B5FD.4020907@suse.de>
Date: Fri, 08 May 2009 10:03:01 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Chris Frey <cdfrey@foursquare.net>, chrisw@sous-sol.org,
       smfrench@gmail.com, jlayton@redhat.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/58] 2.6.29.3-stable review
References: <20090506215017.GA21981@kroah.com> <20090507172301.GA28595@foursquare.net> <20090507221313.GA7126@suse.de>
In-Reply-To: <20090507221313.GA7126@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, May 07, 2009 at 01:23:04PM -0400, Chris Frey wrote:
>> On Wed, May 06, 2009 at 02:50:17PM -0700, Greg KH wrote:
>>> This is the start of the stable review cycle for the 2.6.29.3 release.
>>> There are 58 patches in this series, all will be posted as a response to
>>> this one.
>> Maybe I'm missing something, but I don't see any of
>> the fs/cifs/connect.c security fixes from commits such as
>> f083def68f84b04fe3f97312498911afce79609e.  I was hoping this would make
>> it into 2.6.29.3.
> 
> No one sent them to stable@kernel.org for inclusion :(

Sorry, the patches were sent to cifs mailing list for
consensus/discussion and -stable inclusion request has not happened
(though Steve Cced stable the summary email with his ACK). I'm sending
the patches right away.. and hope it's not too late for 29.3

I have based the patches on top of 2.6.29.2.


Thanks,

-- 
Suresh Jayaraman
