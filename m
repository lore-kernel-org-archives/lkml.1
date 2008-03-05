Return-Path: <linux-kernel-owner+w=401wt.eu-S933050AbYCEMHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbYCEMHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763272AbYCEMHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:07:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45909 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763285AbYCEMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:07:17 -0500
Date: Wed, 5 Mar 2008 06:07:14 -0600
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/2] Cpuset hardwall flag:  Switch cpusets to use the
 bulk cgroup_add_files() API
Message-Id: <20080305060714.f49f0d6a.pj@sgi.com>
In-Reply-To: <20080305080000.270536000@menage.corp.google.com>
References: <20080305075237.608599000@menage.corp.google.com>
	<20080305080000.270536000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> This change tidies up the cpusets control file definitions,

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
