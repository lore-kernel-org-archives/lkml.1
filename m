Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYHRVpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYHRVpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYHRVpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:45:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47652 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbYHRVpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:45:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [linux-pm] forcedeth 10de:0373 doesn't work on resume
Date: Mon, 18 Aug 2008 23:48:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, jgarzik@redhat.com,
       netdev@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, ranma+kernel@tdiedrich.de
References: <4898AA28.8000507@simon.arlott.org.uk> <86802c440808181434q2c3b20fcs197c52c51717e782@mail.gmail.com> <48A9ECE6.3050208@simon.arlott.org.uk>
In-Reply-To: <48A9ECE6.3050208@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182348.53738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of August 2008, Simon Arlott wrote:
> On 18/08/08 22:34, Yinghai Lu wrote:
> > On Mon, Aug 18, 2008 at 2:25 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
> >> On 18/08/08 22:13, Rafael J. Wysocki wrote:
> >>
> >>>> Is it still broken in current kernels?
> >>>
> >>> It probably is.
> >>
> >> If I have MSI enabled, it still doesn't work.
> > 
> > same problem with nv_shutdown about setting it to D3Hot?
> 
> I'm not sure what you're asking here...?

This was a question for me. :-)
