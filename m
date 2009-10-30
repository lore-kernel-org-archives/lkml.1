Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZJ3T2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZJ3T2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZJ3T2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:28:21 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:58800
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbZJ3T2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:28:21 -0400
Date: Fri, 30 Oct 2009 20:28:13 +0100
From: Michael Guntsche <mike@it-loops.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Message-ID: <20091030192813.GA5047@gibson.comsick.at>
References: <20091027095014.GA22215@gibson.comsick.at>
 <200910271138.01624.elendil@planet.nl>
 <20091027140018.GF8900@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027140018.GF8900@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mel and rest of the list,

I have the server running with all with patches applied and it runs
without any issues. Since adding patch5 seems to make a difference I
will revert 1-4 and only apply patch 5 to see if it work too. I will
report back as soon as I have news.

Kind regards,
Michael
