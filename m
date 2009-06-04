Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZFDO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZFDO2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZFDO2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:28:16 -0400
Received: from windsormachine.com ([216.8.138.2]:54567 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZFDO2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:28:15 -0400
Message-ID: <4A27DA01.8060105@windsormachine.com>
Date: Thu, 04 Jun 2009 10:28:17 -0400
From: Mike Dresser <mdresser_l@windsormachine.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A._pF.ZVbIKB@chimera> <20090530231018.GA29992@samad.com.au> <200906012221.38854.rjw@sisk.pl>
In-Reply-To: <200906012221.38854.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am testing 2.6.30-rc8 on the server that has issues with 2.6.29.4, 
I'll most likely know tonight or tomorrow morning if that kernel fixes 
it.. I noticed a lot of xfs changes in rc8 so I figured it was worth a try.

