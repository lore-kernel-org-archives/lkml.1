Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYAHVlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYAHVlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYAHVlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:41:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYAHVlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:41:12 -0500
Date: Tue, 8 Jan 2008 16:41:06 -0500
From: Rik van Riel <riel@redhat.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] Incremental fsck
Message-ID: <20080108164106.735c431d@bree.surriel.com>
In-Reply-To: <200801090022.55589.a1426z@gawab.com>
References: <200801090022.55589.a1426z@gawab.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 00:22:55 +0300
Al Boldi <a1426z@gawab.com> wrote:

> Has there been some thought about an incremental fsck?
> 
> You know, somehow fencing a sub-dir to do an online fsck?

Search for "chunkfs"

-- 
All rights reversed.
