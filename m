Return-Path: <linux-kernel-owner+w=401wt.eu-S934464AbXGWTfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464AbXGWTfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934447AbXGWTeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:34:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56576 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934399AbXGWTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:34:10 -0400
Date: Mon, 23 Jul 2007 12:34:08 -0700
From: Christoph Lameter <clameter@sgi.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
Message-ID: <20070723123408.618ea0a3@schroedinger.engr.sgi.com>
In-Reply-To: <20070717192718.GF3318@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
	<20070717192718.GF3318@linux-os.sc.intel.com>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 12:27:18 -0700
"Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:


> Is there a reason why cpu_sibling_map[] is left out in these changes?

Yes this patch is a trial balloon to make sure that I/we do the right
thing when dealing with the other cpu maps. Patchset will hopefully
soon be forthcoming (after I have dealt with the pile of emails/issues
that came in during my vacation). I'd be glad if someone else could do
it???

Hopefully yours,
	C

