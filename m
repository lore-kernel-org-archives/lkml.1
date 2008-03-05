Return-Path: <linux-kernel-owner+w=401wt.eu-S1765838AbYCEMSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765838AbYCEMSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYCEMR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:17:57 -0500
Received: from relay2.sgi.com ([192.48.171.30]:56414 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752490AbYCEMR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:17:57 -0500
Date: Wed, 5 Mar 2008 06:17:54 -0600
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/2] Cpuset hardwall flag:  Add a mem_hardwall flag to
 cpusets
Message-Id: <20080305061754.61133079.pj@sgi.com>
In-Reply-To: <20080305080000.432133000@menage.corp.google.com>
References: <20080305075237.608599000@menage.corp.google.com>
	<20080305080000.432133000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> This flag provides the hardwalling properties of mem_exclusive,
> without enforcing the exclusivity. Either mem_hardwall or ...

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
