Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZBFABk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZBFABk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZBFABc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:01:32 -0500
Received: from tundra.namei.org ([65.99.196.166]:1396 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbZBFABc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:01:32 -0500
Date: Fri, 6 Feb 2009 11:00:20 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/6] integrity 
In-Reply-To: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0902061059510.13961@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to be getting a bunch of these in my logs with IMA running:

auditd[1746]: dispatch err (Bad address) event lost


-- 
James Morris
<jmorris@namei.org>
