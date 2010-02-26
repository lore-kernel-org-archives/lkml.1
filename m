Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351Ab0BZQdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:33:01 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45067 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331Ab0BZQct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:32:49 -0500
Date: Fri, 26 Feb 2010 16:32:41 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight, classmate-laptop: fix missing registration
	failure handling
Message-ID: <20100226163241.GA20002@srcf.ucam.org>
References: <20100221002831.689bace8@neptune.home> <20100226125939.7cda6d46@neptune.home> <20100226162002.GE23453@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226162002.GE23453@holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If Richard applies my patch to rework backlight registration, this won't 
apply. Richard, what's the situation there?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
