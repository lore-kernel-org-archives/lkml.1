Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbXAWLIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbXAWLIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 06:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXAWLIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 06:08:36 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:24655 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbXAWLIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 06:08:35 -0500
Message-ID: <45B5ECAA.6000100@tls.msk.ru>
Date: Tue, 23 Jan 2007 14:08:26 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.8 (X11/20061128)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan> <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown> <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
[]
> Is this a bug that can or will be fixed or should I disable pre-emption on 
> critical and/or server machines?

Disabling pre-emption on critical and/or server machines seems to be a good
idea in the first place.  IMHO anyway.. ;)

/mjt
