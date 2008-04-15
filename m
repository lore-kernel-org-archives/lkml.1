Return-Path: <linux-kernel-owner+w=401wt.eu-S1764825AbYDOVOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764825AbYDOVOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYDOVOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:14:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbYDOVOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:14:20 -0400
Date: Tue, 15 Apr 2008 14:08:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] eCryptfs: Introduce device handle for userspace
 daemon communications
Message-Id: <20080415140804.4dcd461b.akpm@linux-foundation.org>
In-Reply-To: <20080415202438.GJ18629@localhost.austin.ibm.com>
References: <20080415202313.GM4627@localhost.austin.ibm.com>
	<20080415202438.GJ18629@localhost.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 15:24:38 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> Subject: [PATCH 2/2] eCryptfs: Introduce device handle for userspace daemon communications

This patch has the same title as [1/2].  I renamed it to "eCryptfs:
integrate eCryptfs device handle into the module."
