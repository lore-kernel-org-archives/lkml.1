Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbYEHCI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbYEHCI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYEHCIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:08:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbYEHCIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:08:41 -0400
Date: Wed, 7 May 2008 22:08:25 -0400
From: Rik van Riel <riel@redhat.com>
To: "Kevin Burton" <burton@tailrank.com>
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
Subject: split LRU kernel RPM
Message-ID: <20080507220825.38d85151@bree.surriel.com>
In-Reply-To: <30c6373b0805051400jebd4132ob23ec38bdf1ccb93@mail.gmail.com>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	<20080505131607.5556b1f2@olorin>
	<30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	<20080505212831.22371732@olorin>
	<30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	<20080505164446.2ec9a543@cuia.bos.redhat.com>
	<30c6373b0805051400jebd4132ob23ec38bdf1ccb93@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 14:00:51 -0700
"Kevin Burton" <burton@tailrank.com> wrote:

> > I have no such tunable in my code (yet), because I would like the
> > kernel to do the right thing automatically.  I will post a 2.6.25 based
> > kernel RPM for Fedora 9 soon with the split LRU patch series applied.

I have created a 2.6.25 based split LRU kernel RPM for Fedora 9:

http://people.redhat.com/riel/splitvm/

The srpm and x86-64 RPMs are there.  The i686 kernel RPM is
still compiling, I will upload it tomorrow morning.

-- 
All rights reversed.
