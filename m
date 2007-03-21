Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbXCUMkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbXCUMkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbXCUMkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:40:08 -0400
Received: from smtp.nokia.com ([131.228.20.173]:42657 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXCUMkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:40:06 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070321123136.GA495@lazybastard.org>
References: <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
	 <20070321113523.GD3785@lazybastard.org>
	 <1174478263.10840.56.camel@localhost.localdomain>
	 <20070321123136.GA495@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Mar 2007 14:39:27 +0200
Message-Id: <1174480767.17249.201.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Mar 2007 12:39:28.0150 (UTC) FILETIME=[F70E2360:01C76BB5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 13:31 +0100, Jörn Engel wrote:
> Correct.  It may make sense to use UBI for that, I don't know.  What I
> do know is that UBI cannot make wear leveling decisions as well as
> LogFS.

So lets discuss this in different thread when you post a request to
include LogFS into mainline.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

