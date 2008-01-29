Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbYA2Tvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbYA2Tvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYA2Tvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:51:37 -0500
Received: from relay2.sgi.com ([192.48.171.30]:60234 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751196AbYA2Tvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:51:36 -0500
Date: Tue, 29 Jan 2008 11:51:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 4/6] MMU notifier: invalidate_page callbacks using Linux
 rmaps
In-Reply-To: <20080129142452.GH7233@v2.random>
Message-ID: <Pine.LNX.4.64.0801291151170.24807@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202924.334342410@sgi.com>
 <20080129140345.GG7233@v2.random> <20080129142452.GH7233@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks I will put that into V3.

