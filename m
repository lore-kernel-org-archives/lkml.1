Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYFYTzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYFYTzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYFYTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:55:04 -0400
Received: from testure.choralone.org ([194.9.77.134]:58522 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYFYTzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:55:02 -0400
Date: Wed, 25 Jun 2008 16:00:01 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug
	in workqueue.c
Message-ID: <20080625200001.GE30955@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Johannes Weiner <hannes@saeurebad.de>,
	Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
	ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
References: <485F8028.1070302@linux.vnet.ibm.com> <87y74w41fp.fsf@skyscraper.fehenstaub.lan> <4860BB8E.2070505@linux.vnet.ibm.com> <87tzfh2t5l.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tzfh2t5l.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 09:47:50PM +0200, Johannes Weiner wrote:

 > Cool, thanks for testing!
 > 
 > I think the above patch is right but not enough.
 > 
 > Dave, what do you think about the following?

Makes sense to me.  I'll queue it up.

	Dave

-- 
http://www.codemonkey.org.uk
