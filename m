Return-Path: <linux-kernel-owner+w=401wt.eu-S1765667AbYCEK30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765667AbYCEK30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763985AbYCEK3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:29:16 -0500
Received: from viefep31-int.chello.at ([62.179.121.49]:64484 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761705AbYCEK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:29:15 -0500
Subject: Re: [PATCH 0/2] CGroups _s64 files: Intro
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: menage@google.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
In-Reply-To: <20080305102025.677459000@menage.corp.google.com>
References: <20080305102025.677459000@menage.corp.google.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 11:29:09 +0100
Message-Id: <1204712949.8514.51.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 02:20 -0800, menage@google.com wrote:
> These patches add cgroups read_s64 and write_s64 control file methods
> (the signed equivalent of read_u64/write_u64) and use them to
> implement the cpu.rt_runtime_us control file in the CFS cgroup
> subsystem.
> 
> Signed-off-by: Paul Menage <menage@google.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>



