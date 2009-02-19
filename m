Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbZBSNiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbZBSNiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZBSNik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:38:40 -0500
Received: from lucidpixels.com ([75.144.35.66]:34662 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZBSNij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:38:39 -0500
Date: Thu, 19 Feb 2009 08:38:38 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Subject: General question (scheduler) with SSDs?
Message-ID: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was curious if anyone had done any benchmarks and/or has conclusive 
information, what is the best Linux scheduler to use with SSDs?

Noop?
CFQ?
AS?
Deadline?

Justin.

