Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZDVUas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZDVUas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZDVUaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:30:39 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49764 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZDVUaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:30:39 -0400
Date: Wed, 22 Apr 2009 16:20:49 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/22] Do not sanity check order in the fast path
In-Reply-To: <alpine.DEB.2.00.0904221244030.14558@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0904221620370.18138@qirst.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-3-git-send-email-mel@csn.ul.ie> <1240416791.10627.78.camel@nimitz> <20090422171151.GF15367@csn.ul.ie> <alpine.DEB.2.00.0904221244030.14558@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Acked-by: Christoph Lameter <cl@linux-foundation.org>


