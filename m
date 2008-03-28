Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYC1S2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYC1S2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYC1S2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:28:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50452 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbYC1S2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:28:43 -0400
Date: Fri, 28 Mar 2008 19:28:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Pull] Some documentation patches
In-Reply-To: <13387.1206728412@vena.lwn.net>
Message-ID: <alpine.LNX.1.10.0803281927460.27567@fbirervta.pbzchgretzou.qr>
References: <13387.1206728412@vena.lwn.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-03-28 19:20, Jonathan Corbet wrote:
>
>  git://git.lwn.net/linux-2.6.git docs

$ git remote add doc git://git.lwn.net/linux-2.6.git

$ git-fetch doc
fatal: Unable to look up git.lwn.net (port 9418) (Name or service not known)
