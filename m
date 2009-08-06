Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZHFPOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZHFPOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZHFPOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:14:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbZHFPOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:14:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] PM: Add convenience macro to make switching to dev_pm_ops less error-prone
Date: Thu, 6 Aug 2009 17:14:22 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, Frans Pop <elendil@planet.nl>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       albin.tonnerre@free-electrons.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20090803163304.GF5002@laptop> <200908061416.08564.rjw@sisk.pl> <aec7e5c30908060610l7edab1c1oae08720a675937a9@mail.gmail.com>
In-Reply-To: <aec7e5c30908060610l7edab1c1oae08720a675937a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061714.22449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Magnus Damm wrote:
> On Thu, Aug 6, 2009 at 9:16 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > On Thursday 06 August 2009, Daniel Mack wrote:
> >> When is a good point to resend patches that use this macro? I guess they
> >> won't make it to .31 anyway, right? So I just wait for the next merge
> >> window?
> >
> > Yes, I think that would be the right thing to do.
> 
> Is it a good idea to disable the warning before the final 2.6.31 release?

I guess so.  Let's disable it.

Thanks,
Rafael
