Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZKRB23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZKRB23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbZKRB21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:28:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbZKRB2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:28:20 -0500
Date: Tue, 17 Nov 2009 19:29:03 -0500
From: Dave Jones <davej@redhat.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH 3/3] [CPUFREQ] make internal cpufreq_add_dev_* static
Message-ID: <20091118002903.GA14477@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org,
	cpufreq@vger.kernel.org
References: <20091117220729.25933.57884.stgit@bob.kio>
 <20091117221130.25933.92163.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117221130.25933.92163.stgit@bob.kio>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:11:30PM -0700, Alex Chiang wrote:
 > No need to export these symbols; make them static.
 > 
 > 	cpufreq_add_dev_policy
 > 	cpufreq_add_dev_symlink
 > 	cpufreq_add_dev_interface
 > 
 > Signed-off-by: Alex Chiang <achiang@hp.com>
 
Ok. But can you move the parameters to the next line, so that
checkpatch doesn't whine ?

thanks.

	Dave

