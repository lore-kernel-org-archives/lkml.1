Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbYBOKp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbYBOKp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbYBOKpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:45:21 -0500
Received: from hel.is.scarlet.be ([193.74.71.26]:36012 "EHLO hel.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbYBOKpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:45:20 -0500
Date: Fri, 15 Feb 2008 11:44:52 +0100
Message-Id: <JWA0IS$52EB33BDF46A1EBD2B77B8DCB8FC63DF@scarlet.be>
Subject: Re: parisc compile error
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "rubisher" <rubisher@scarlet.be>
To: "kyle" <kyle@mcmartin.ca>
Cc: "kyle" <kyle@mcmartin.ca>, "clameter" <clameter@sgi.com>,
       "bunk" <bunk@kernel.org>, "kyle" <kyle@parisc-linux.org>,
       "matthew" <matthew@wil.cx>, "grundler" <grundler@parisc-linux.org>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "rubisher" <rubisher@scarlet.be>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
X-DCC-scarlet.be-Metrics: hel; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Feb 13, 2008 at 01:42:10PM +0100, rubisher wrote:
> >     - some lake of changes of kset to kobj:
> 
> thanks, i don't build this driver, somehow it made its way out of my
> configs. patch looks correct though. applied.
> 
Cool ;-)

Btw, it boot fine to me on b2k and d380 running all up 32bit kernels ;-)

Cheers,
    r.
---
Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
http://www.scarlet.be/

