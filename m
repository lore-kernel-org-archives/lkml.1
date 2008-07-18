Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYGRO4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYGRO4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYGRO4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:56:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbYGRO4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:56:41 -0400
Message-ID: <4880AEFE.3060909@linux-foundation.org>
Date: Fri, 18 Jul 2008 09:55:58 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory	usage	of	some
 key caches
References: <1216211371.3122.46.camel@castor.localdomain>	 <487DF5D4.9070101@linux-foundation.org>	 <1216216730.3122.60.camel@castor.localdomain>	 <487DFFBE.5050407@linux-foundation.org>	 <1216375025.3082.7.camel@castor.localdomain>	 <4880A694.1000100@linux-foundation.org> <1216392177.3082.27.camel@castor.localdomain>
In-Reply-To: <1216392177.3082.27.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK that is now 4215 pages before and 4112 after the patch? Yawn.... So barely any effect?
