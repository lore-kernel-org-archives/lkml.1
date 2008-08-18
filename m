Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYHRVjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYHRVjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYHRVi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:38:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47611 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYHRVi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:38:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [linux-pm] forcedeth 10de:0373 doesn't work on resume
Date: Mon, 18 Aug 2008 23:42:31 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Simon Arlott" <simon@fire.lp0.eu>,
       "Andrew Morton" <akpm@linux-foundation.org>, jgarzik@redhat.com,
       netdev@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, ranma+kernel@tdiedrich.de
References: <4898AA28.8000507@simon.arlott.org.uk> <48A9E8B3.4040800@simon.arlott.org.uk> <86802c440808181434q2c3b20fcs197c52c51717e782@mail.gmail.com>
In-Reply-To: <86802c440808181434q2c3b20fcs197c52c51717e782@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808182342.32039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of August 2008, Yinghai Lu wrote:
> On Mon, Aug 18, 2008 at 2:25 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
> > On 18/08/08 22:13, Rafael J. Wysocki wrote:
> >
> >>> Is it still broken in current kernels?
> >>
> >> It probably is.
> >
> > If I have MSI enabled, it still doesn't work.
> 
> same problem with nv_shutdown about setting it to D3Hot?

Well, maybe.  The only way to verify that would be to try with MSI
disabled. ;-)

Thanks,
Rafael
