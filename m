Return-Path: <linux-kernel-owner+w=401wt.eu-S1764428AbXFKK0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764428AbXFKK0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 06:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbXFKKZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 06:25:57 -0400
Received: from max.aladin.ro ([80.96.155.2]:59917 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbXFKKZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 06:25:57 -0400
Message-ID: <466D2342.6010507@aladin.ro>
Date: Mon, 11 Jun 2007 13:26:10 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: jdike@karaya.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UML: fix missing non-blocking I/O, now DEBUG_SHIRQ
 works
References: <1181514048.3157.9.camel@localhost>
In-Reply-To: <1181514048.3157.9.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Eduard-Gabriel Munteanu wrote:
> The patch was written and tested on Linux 2.6.22-rc2-mm1. 

Also tested on git. I forgot to tell you the diff is done against git 
(it was made on that -mm, diffed, applied to git and then git-diffed 
against HEAD).
