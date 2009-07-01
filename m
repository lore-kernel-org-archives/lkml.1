Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZGAKdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZGAKdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZGAKds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:33:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45151 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZGAKdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:33:47 -0400
Date: Wed, 1 Jul 2009 12:33:14 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: KSM: current madvise rollup
Message-ID: <20090701103314.GB14272@random.random>
References: <Pine.LNX.4.64.0906291419440.5078@sister.anvils>
 <4A49E051.1080400@redhat.com>
 <Pine.LNX.4.64.0906301518370.967@sister.anvils>
 <4A4A5C56.5000109@redhat.com>
 <Pine.LNX.4.64.0907010057320.4255@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907010057320.4255@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh!

On Wed, Jul 01, 2009 at 03:03:58AM +0100, Hugh Dickins wrote:
> up with evidence for doing it differently - I think there's scope
> for academic papers on the behaviour of the unstable tree.

Eheh, I covered some of the behaviour of the unstable tree in the KSM
paper @ LinuxSymposium (downloadable in a few weeks) and I will ""try""
to cover some of it in my presentation as well ;).
