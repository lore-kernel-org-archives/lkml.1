Return-Path: <linux-kernel-owner+w=401wt.eu-S1765182AbXHHQy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765182AbXHHQy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763284AbXHHQyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:54:16 -0400
Received: from smtp.nokia.com ([131.228.20.171]:23400 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763311AbXHHQyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:54:13 -0400
Subject: Re: LogFS take five
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070808163545.GU15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
	 <1186590437.19606.38.camel@sauron> <20070808163545.GU15319@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 08 Aug 2007 19:52:00 +0300
Message-Id: <1186591920.19606.45.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 08 Aug 2007 16:52:01.0471 (UTC) FILETIME=[70F86CF0:01C7D9DC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 18:35 +0200, Jörn Engel wrote:
> Scanning.  I don't have seperate accounting yet.

Ok, but how are you going to implement it? Surely you cannot say that
LogFS is scalable before you have better space accounting (or you at
least should note that it is scalable up to some limit).

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

