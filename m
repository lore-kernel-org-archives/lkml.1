Return-Path: <linux-kernel-owner+w=401wt.eu-S933466AbZKXQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbZKXQX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933375AbZKXQX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:23:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbZKXQXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:23:25 -0500
Message-ID: <4B0C087E.6050701@sandeen.net>
Date: Tue, 24 Nov 2009 10:23:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Which kernel options should be enabled to find the root cause
 of this bug?
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0911240805490.25676@p34.internal.lan> <4B0BF866.7040004@sandeen.net> <alpine.DEB.2.00.0911241115080.7755@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0911241115080.7755@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> On Tue, 24 Nov 2009, Eric Sandeen wrote:

...

>> Do you get the same behavior if you don't add the log options at mount time?
> I have not tried disabling the log options, although they have been in effect
> for a long time, (the logsbufs and bufsize and recently) the nobarrier
> support.  Could there be an issue using -o nobarrier on a raid1+xfs?

nobarrier should not cause problems.

-Eric
