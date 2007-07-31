Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXGaQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXGaQaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbXGaQaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:30:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51400 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbXGaQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:30:38 -0400
Subject: Re: [PATCH] Make headers_check less chatty for success cases
From: David Woodhouse <dwmw2@infradead.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707312206140.28746@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312206140.28746@enigma.security.iitk.ac.in>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 17:30:09 +0100
Message-Id: <1185899409.3083.122.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 22:10 +0530, Satyam Sharma wrote:
> "make headers_check" is too verbose. It likes to chat even if it has
> just _successfully_ checked a header, and not just on seeing errors.
> What is worse, even if you touch just one little header in some corner
> (or possibly none) and type "make" on an "already-made" tree,
> headers_check still feels obliged to check all the headers.

Didn't Sam have a better fix for that?

-- 
dwmw2

