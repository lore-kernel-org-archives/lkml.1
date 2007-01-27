Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbXA0VEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbXA0VEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbXA0VEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:04:55 -0500
Received: from twin.jikos.cz ([213.151.79.26]:40564 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089AbXA0VEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:04:54 -0500
Date: Sat, 27 Jan 2007 22:04:29 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Lee Revell <rlrevell@joe-job.com>,
       Gianluca Alberici <gianluca@abinetworks.biz>
cc: linux-kernel@vger.kernel.org
Subject: Re: Nozmi status ?
In-Reply-To: <75b66ecd0701271218q428e958cvc8cda7c356c315e3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701272149320.9448@twin.jikos.cz>
References: <45BB3FFF.1090806@abinetworks.biz>
 <75b66ecd0701271218q428e958cvc8cda7c356c315e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007, Lee Revell wrote:

> > What is the status of the HSDPA driver after 2.6.19.1 ? Is it part of 
> > the kernel tree or not yet ? If not is there any version of ther 
> > nozomi pack which is gonna compile under ker > 2.6.18 (the original 
> > one is not compiling anymore after 2.6.18).
> It's up to the vendor to fix the driver to work with newer kernels
> and/or submit the driver for inclusion in the kernel.  Do you know
> whether they've done that?

There is a nozomi HSDPA driver in recent -mm kernels which compiles 
(gregkh-driver-nozomi.patch).

-- 
Jiri Kosina
