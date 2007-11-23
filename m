Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbXKWW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbXKWW3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 17:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbXKWW3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 17:29:33 -0500
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:61768 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923AbXKWW3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 17:29:32 -0500
Date: Fri, 23 Nov 2007 23:29:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: benh@kernel.crashing.org, Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       linux-kernel@vger.kernel.org, Dennis Munsie <dmunsie@cecropia.com>
Subject: Re: radeonfb i2c regression post-2.6.18.
Message-ID: <20071123232928.467378a7@hyperion.delvare>
In-Reply-To: <200711231700.53103.mb@bu3sch.de>
References: <1195427766.7022.18.camel@pasglop>
	<200711231700.53103.mb@bu3sch.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2007 17:00:52 +0100, Michael Buesch wrote:
> This patch fixes my crash problem.

Out of curiosity, what kind of crash was it? I admit that I can't see
how the code could crash.

-- 
Jean Delvare
