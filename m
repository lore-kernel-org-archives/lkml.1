Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbXH1SMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbXH1SMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXH1SMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:12:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38600 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbXH1SMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:12:44 -0400
Date: Tue, 28 Aug 2007 20:12:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ok to kill "ether=" kernel parm?
In-Reply-To: <46D45A02.6010306@zytor.com>
Message-ID: <Pine.LNX.4.64.0708282012290.3018@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain>
 <46D45111.2040600@zytor.com> <Pine.LNX.4.64.0708281300030.18151@localhost.localdomain>
 <46D45A02.6010306@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 10:23, H. Peter Anvin wrote:
>
>What's the upside of changing?  What's the downside?  The upside is so
>infinitesimal that that leaving "ether=" in indefinitely seems like a
>good move to me.

Then why did it change to netdev= in the first place...



	Jan
-- 
