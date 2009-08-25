Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZHYLhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZHYLhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZHYLhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:37:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38750 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZHYLhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:37:18 -0400
Date: Tue, 25 Aug 2009 13:36:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: mmi@superbash.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD K10 temp.module ready since months, but missing in
	kernel...
Message-ID: <20090825113658.GD1341@ucw.cz>
References: <20090821001322.470bb177@p4laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821001322.470bb177@p4laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-08-21 00:13:22, mmi wrote:
> Hello out there,
> 
> i found the code to read temperature of AMD K10 (Phenom) processors a
> couple of months ago in the net (GPL). I use it since January now and i
> wonder, why it's not in the kernel till now.
> 
> It's from the same author, who wrote k8temp.c (which is in kernel).

So perhaps you need to clean it up and submit for mainline? Or just
submit for staging?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
