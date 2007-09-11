Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXIKPiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXIKPiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXIKPhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:37:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49884 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbXIKPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:37:53 -0400
Date: Tue, 11 Sep 2007 17:37:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Hookup group-scheduler with task container infrastructure
In-Reply-To: <20070911082243.9433c528.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0709111737000.9962@fbirervta.pbzchgretzou.qr>
References: <20070910171049.GA16048@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
 <20070910172334.GB19100@linux.vnet.ibm.com> <20070910102259.dc45a481.akpm@linux-foundation.org>
 <20070910174649.GA16222@linux.vnet.ibm.com> <b647ffbd0709101537l9af4dc8x743b25c96e0f5235@mail.gmail.com>
 <6599ad830709101545s66fd338dob6932407db4e1002@mail.gmail.com>
 <46E641C1.8000808@fr.ibm.com> <20070911082243.9433c528.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 11 2007 08:22, Randy Dunlap wrote:
>> "cfs" control group subsystem.
>
>That looks odd, like it's a filesystem.
>What does cfs really mean?

http://en.wikipedia.org/wiki/CFS
(scnr)

It misses the C...something Filesystem tho.



	Jan
-- 
