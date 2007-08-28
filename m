Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXH1Snk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXH1Snk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXH1Snd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:43:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXH1Snc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:43:32 -0400
Message-Id: <200708281843.l7SIhJ9D010636@terminus.zytor.com>
MIME-Version: 1.0
content-class: 
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: ok to kill "ether=" kernel parm?
Date: Tue, 28 Aug 2007 11:43:26 -0700
Importance: normal
X-Priority: 3
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It changed to be more descriptive.  The old one is supported for backwards compatibility, just like we have sys_oldoldstat still.

(sent front cellphone) 

-----Original Message-----
From: Jan Engelhardt <jengelh@computergmbh.de>
Sent: Tuesday, August 28, 2007 11:12
To: H. Peter Anvin <hpa@zytor.com>
Cc: Robert P. J. Day <rpjday@mindspring.com>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ok to kill "ether=" kernel parm?


On Aug 28 2007 10:23, H. Peter Anvin wrote:
>
>What's the upside of changing?  What's the downside?  The upside is so
>infinitesimal that that leaving "ether=" in indefinitely seems like a
>good move to me.

Then why did it change to netdev= in the first place...



	Jan
-- 

