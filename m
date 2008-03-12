Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbYCLHdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYCLHdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYCLHc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:32:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbYCLHc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:32:58 -0400
Date: Wed, 12 Mar 2008 00:32:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
Message-Id: <20080312003227.a94580e8.akpm@linux-foundation.org>
In-Reply-To: <10815.1204862325@turing-police.cc.vt.edu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<10815.1204862325@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2008 22:58:45 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 04 Mar 2008 01:19:28 PST, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> 
> Dell Latitude D820, x86_64, Core2 Duo T7200
> 
> 'shutdown -h' blows up at the very end. shutdown -r works OK.

Did rc5-mm1 fix this?
