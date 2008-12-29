Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbYL2Uvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbYL2Uvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYL2UvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:51:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbYL2UvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:51:23 -0500
Date: Mon, 29 Dec 2008 12:50:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] exofs: super_operations and file_system_type
Message-Id: <20081229125035.741fb6fc.akpm@linux-foundation.org>
In-Reply-To: <4947C9D2.5080405@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<4947C9D2.5080405@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:31:30 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> +struct super_operations exofs_sops = {

const.  I'm sure I missed many of these.

