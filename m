Return-Path: <linux-kernel-owner+w=401wt.eu-S1765450AbXE2S5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765450AbXE2S5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763931AbXE2S44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:56:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44105 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447AbXE2S4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:56:54 -0400
Date: Tue, 29 May 2007 20:57:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tej Parkash <tejparkash.d@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: warning while building module.
Message-ID: <20070529185725.GC5846@uranus.ravnborg.org>
References: <2bd9ebfa0705282145t34ed211bs48c7b31fcd9420a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bd9ebfa0705282145t34ed211bs48c7b31fcd9420a5@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 10:15:58AM +0530, Tej Parkash wrote:
> hi all
> 
> while building module i was getting following warning and it terminate
> module building stage
The below are only warnings and your build should succeed.

It is obviously i386 - is it a clean allmodconfig or any changes?
Is it latest -linus or some older version of the codebase?

	Sam
