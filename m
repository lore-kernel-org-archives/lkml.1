Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZGHRRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZGHRRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZGHRRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:17:10 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36401 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753728AbZGHRRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:17:09 -0400
Date: Wed, 8 Jul 2009 13:16:32 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, alex.shi@intel.com,
       Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       yanmin.zhang@intel.com, tim.c.chen@intel.com
Subject: Re: [PATCH] x86: don't clear nodes_states[N_NORMAL_MEMORY] when numa
 is not compiled in -v2
In-Reply-To: <4A54CE4B.9080403@kernel.org>
Message-ID: <alpine.DEB.1.10.0907081316100.23568@gentwo.org>
References: <bug-13690-10286@http.bugzilla.kernel.org/>  <20090701183452.8660c8a9.akpm@linux-foundation.org>  <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp> <4A4C74D8.30809@kernel.org> <alpine.DEB.1.10.0907021003450.16359@gentwo.org>
 <4A54CE4B.9080403@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

