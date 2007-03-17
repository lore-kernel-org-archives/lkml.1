Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbXCQHZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbXCQHZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 03:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXCQHZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 03:25:43 -0400
Received: from holomorphy.com ([66.93.40.71]:46420 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbXCQHZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 03:25:42 -0400
Date: Sat, 17 Mar 2007 00:25:35 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Nicholas Miell <nmiell@comcast.net>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RSDL v0.31
Message-ID: <20070317072535.GA2986@holomorphy.com>
References: <200703042335.26785.a1426z@gawab.com> <200703170040.48316.kernel@kolivas.org> <1174059299.7886.25.camel@Homer.simpson.net> <200703170813.32594.kernel@kolivas.org> <1174084207.7009.9.camel@Homer.simpson.net> <1174105443.3144.4.camel@entropy> <1174110965.7911.44.camel@Homer.simpson.net> <1174112768.3144.8.camel@entropy> <1174115517.7911.66.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174115517.7911.66.camel@Homer.simpson.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 08:11:57AM +0100, Mike Galbraith wrote:
> On a side note, I wonder how long it's going to take to fix all the
> X/client combinations out there.

AIUI X's clients largely access it via libraries X ships, so the X
update will sweep the vast majority of them in one shot. You'll have
to either run the clients from remote hosts with downrev libraries or
have downrev libraries around (e.g. in chroots) for clients to link to
for the clients not to cooperate.


-- wli
