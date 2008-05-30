Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYE3N5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYE3N5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYE3N5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:57:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49966 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYE3N5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:57:23 -0400
Date: Fri, 30 May 2008 06:57:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Guntsche Michael <mike@it-loops.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
Message-ID: <20080530065717.44cf7414@infradead.org>
In-Reply-To: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com>
References: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008 15:44:55 +0200
Guntsche Michael <mike@it-loops.com> wrote:

> Since the server is idling most of the time I enabled the ondemand  
> governor and installed p4-clockmod. I read that this is not the best  
> solution but acpi-cpufreq is not working for me.

... and it's not the best solution because it's not saving you any
energy...
(in fact it may cost you some)

p4-clockmod should go away.
(at least as cpufreq driver)
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
