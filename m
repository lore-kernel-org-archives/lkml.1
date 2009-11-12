Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZKLWva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZKLWva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZKLWv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:51:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbZKLWv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:51:27 -0500
Date: Thu, 12 Nov 2009 14:51:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH 10/17] hpsa:  Allow device rescan to be triggered via
 sysfs.
Message-Id: <20091112145124.2e8ada8b.akpm@linux-foundation.org>
In-Reply-To: <20091111165114.17754.83467.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
	<20091111165114.17754.83467.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 10:51:14 -0600
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> Allow device rescan to be triggered via sysfs.

When adding a new userspace interface to the kernel, please fully
describe that interface in the changelog.

Is there somewhere where this should have been documented?
