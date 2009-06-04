Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZFDOkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZFDOkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZFDOkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:40:00 -0400
Received: from windsormachine.com ([216.8.138.2]:38479 "EHLO
	router.windsormachine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFDOj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:39:59 -0400
Date: Thu, 4 Jun 2009 10:40:01 -0400 (EDT)
From: Mike Dresser <mdresser_l@windsormachine.com>
To: Christoph Hellwig <hch@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alex Samad <alex@samad.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
In-Reply-To: <20090604143406.GA19536@infradead.org>
Message-ID: <alpine.DEB.1.10.0906041038500.15712@router.windsormachine.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A._pF.ZVbIKB@chimera> <20090530231018.GA29992@samad.com.au> <200906012221.38854.rjw@sisk.pl> <4A27DA01.8060105@windsormachine.com> <20090604143406.GA19536@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-scanner: Scanned by Xamime-LT 0.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Christoph Hellwig wrote:

> Can you please also run with CONFIG_XFS_DEBUG enabled so that all
> kinds of asserts might trigger?

The help for that option says the "code will be HUGE and SLOW"

How much of a slowdown are we likely talking about?

Mike


