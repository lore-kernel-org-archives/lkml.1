Return-Path: <linux-kernel-owner+w=401wt.eu-S1422899AbXBGWOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422899AbXBGWOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXBGWOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:14:43 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37833 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422899AbXBGWOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:14:42 -0500
Message-ID: <45CA4F3A.5080000@garzik.org>
Date: Wed, 07 Feb 2007 17:14:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: csnook@redhat.com, bunk@stusta.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH netdev#atl1 1/1] atl1: clean up extern, global scope declarations
References: <20070207023453.GA2657@osprey.hogchain.net>
In-Reply-To: <20070207023453.GA2657@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> From: Jay Cliburn <jacliburn@bellsouth.net>
> 
> atl1: move extern to header file; make some global code static
> 
> Move an extern declaration to a header file.  Make needlessly global
> functions static.  Noticed by Adrian Bunk.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>

applied


