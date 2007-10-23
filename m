Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXJWCi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXJWCi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXJWCiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:38:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbXJWCiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:38:21 -0400
Date: Mon, 22 Oct 2007 19:38:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Philippe Elie <phil.el@wanadoo.fr>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sami Farin <safari-kernel@safari.iki.fi>
Subject: Re: [patch 1/2] oProfile: oops when profile_pc() return ~0LU
In-Reply-To: <20071021120842.GA2886@zaniah>
Message-ID: <alpine.LFD.0.999.0710221936130.30120@woody.linux-foundation.org>
References: <20071021120842.GA2886@zaniah>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This set of two patches look ok by me, but I'd like sign-offs.. Also, were 
they tested and found to fix the problem by Sami?

		Linus
