Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXK0Wyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXK0Wyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbXK0Wyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:54:38 -0500
Received: from mail.fieldses.org ([66.93.2.214]:52619 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbXK0Wyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:54:37 -0500
Date: Tue, 27 Nov 2007 17:54:36 -0500
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: git guidance
Message-ID: <20071127225436.GJ27242@fieldses.org>
References: <474C9B31.8000408@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474C9B31.8000408@imap.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 11:33:21PM +0100, Tilman Schmidt wrote:
> Does somebody have a step by step tutorial for doing the standard
> "edit - test - modify - retest - submit - edit - resubmit" sequence
> with GIT? Is there a GIT newsgroup or mailinglist? Or should I just
> post my silly questions to LKML?

It's git@vger.kernel.org.

If you post there more specifics about what you tried and what the
results were, they might be able to figure out what happened.

Also, specifics about which documentation you read would help improve
the docs.  I believe that the in-tree beginner's documentation (the
"tutorial" and the "user manual"--also the first hits for "git tutorial"
and "git user manual" on google) explain how to do what you need, but
perhaps it's not obvious where.

--b.
