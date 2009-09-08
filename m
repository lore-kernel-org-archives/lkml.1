Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZIHNSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZIHNSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZIHNSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:18:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZIHNSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:18:35 -0400
Subject: Re: Stop using tasklets for bottom halves
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Matt Smith <Matt.Smith@atheros.com>, Kevin Hayes <kevin@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, ic.felix@gmail.com
In-Reply-To: <43e72e890909072116v33ecafc4ma7f5a68825f14e9@mail.gmail.com>
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com>
	 <20090907171406.6a4b6116@nehalam>
	 <1252376254.21261.2052.camel@gandalf.stny.rr.com>
	 <43e72e890909072116v33ecafc4ma7f5a68825f14e9@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 09:18:34 -0400
Message-Id: <1252415914.13628.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 21:16 -0700, Luis R. Rodriguez wrote:
> On Mon, Sep 7, 2009 at 7:17 PM, Steven Rostedt<rostedt@goodmis.org> wrote:

> >>
> >> Process context is too slow.
> >
> > Well, I'm hoping to prove the opposite. I'm working on some stuff that I
> > plan to present at Linux Plumbers. I've been too distracted by other
> > things, but hopefully I'll have some good numbers to present by then.
> 
> What day in specific was this planned for at Plumbers?

Wednesday, during the networking session.

  http://linuxplumbersconf.org/ocw/proposals/53

-- Steve


