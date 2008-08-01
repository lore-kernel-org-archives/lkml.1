Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbYHAWL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbYHAWL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYHAWLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:11:48 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:55615 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYHAWLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:11:48 -0400
Date: Sat, 2 Aug 2008 00:12:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Adrian Bunk <bunk@kernel.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sh O= builds broken
Message-ID: <20080801221222.GA14125@uranus.ravnborg.org>
References: <20080801212728.GF19682@cs181140183.pp.htv.fi> <20080801215338.GC13448@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801215338.GC13448@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 06:53:38AM +0900, Paul Mundt wrote:
> > 
> Ok, so this is what I get for moving the auto-generated header outside of
> include/asm-sh.. it seemed like a good idea at the time.
Ups - I should have caught that when I reviewd your initial patch.
kbuild does on purpose not fiddle with the path in the inital
include specification.

	Sam
