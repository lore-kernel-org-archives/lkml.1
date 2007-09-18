Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXIRFAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXIRFAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 01:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXIRFAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 01:00:48 -0400
Received: from 1wt.eu ([62.212.114.60]:2544 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXIRFAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 01:00:47 -0400
Date: Tue, 18 Sep 2007 07:00:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Rigg <cdrigg@comcast.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFS patch (v6) -- dynamic RT priorities?
Message-ID: <20070918050043.GE10199@1wt.eu>
References: <46EEE498.1080500@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EEE498.1080500@comcast.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 02:33:28PM -0600, Chris Rigg wrote:
> Hello,
> 
> I have a system with 2.6.20.7 patched with the v6 CFS patch. I am having 
> issues (I believe) with fairness in regards to my real-time tasks. 
> First, let me describe my setup:

Chris,

CFSv6 is *very* old. It was not that bad, but looking back, it has
improved a lot since. You should upgrade to v20.x first, and it's
likely that most of your problems will vanish.

Regards,
willy

