Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbXJaSOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbXJaSOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 14:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXJaSO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 14:14:29 -0400
Received: from empbedex1.empirix.com ([12.38.203.54]:52748 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXJaSO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 14:14:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Update (Now a False Alarm) RE: Other Problems with Marvell Driver - 7042 (2.6.23)...
Date: Wed, 31 Oct 2007 14:14:18 -0400
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010A825872@EMPBEDEX.empirix.com>
In-Reply-To: <4728A816.8020608@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Update (Now a False Alarm) RE: Other Problems with Marvell Driver - 7042 (2.6.23)...
Thread-Index: Acgb2OVOCBE2GvRQT0yuQEw5hg7XMAAEDO+Q
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Kumar Gala" <galak@kernel.crashing.org>
X-OriginalArrivalTime: 31 Oct 2007 18:14:27.0369 (UTC) FILETIME=[DFA79190:01C81BE9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff / all -

Jeff is (again) 100% correct with comments - the sata_mv.c I used 
from Kumar's 2.6.23 Powerpc tree is very *close*, but not exactly 
the same as the sata_mv.c in the 'official' 2.6.23.1 tree.

I have verified that I now can access my disks behind the 7042 chip
with the 'mainline' 2.6.23.1 (and my bsp)...

Sorry for the false alarm - thank you Jeff for pointing me in the right
direction with this!

Sincerely,

Tom Morrison


-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Wednesday, October 31, 2007 12:07 PM
To: Morrison, Tom
Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; Kumar Gala
Subject: Re: Other Problems with Marvell Driver - 7042 (2.6.23)...

Morrison, Tom wrote:


<snip description of problem>

==========Jeff writes=====

First you need to try 2.6.23.1 rather than 2.6.23, because it contains a

critical sata_mv fix.

	Jeff



