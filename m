Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbYDKSjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbYDKSjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbYDKSiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:38:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759846AbYDKSiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:38:54 -0400
Message-ID: <47FFB03A.8060305@redhat.com>
Date: Fri, 11 Apr 2008 14:38:50 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <632977.6298.qm@web52505.mail.re2.yahoo.com>
In-Reply-To: <632977.6298.qm@web52505.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> I was just wondering if there were any known issues
> with AMD quad core phenom clock drift problems? I';m
> running a 2.6.24 kernel and it's losing time. I
> remember the first dual core AMD chips had a lot of
> clock issues.
> 
> If this is something new let me know what information
> to check and post to this list.

When reporting clock problems, please post dmesg.  This has all the 
interesting timekeeping-related log messages from the kernel.  Please 
also describe the drift quantitatively.

-- Chris
