Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZJAVbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZJAVbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZJAVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:31:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbZJAVbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:31:13 -0400
Date: Thu, 1 Oct 2009 14:30:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
Subject: Re: [PATCH] Add hpsa driver for HP Smart Array controllers.
Message-Id: <20091001143035.a83a7564.akpm@linux-foundation.org>
In-Reply-To: <20091001211705.15591.76403.stgit@beardog.cce.hp.com>
References: <20091001211705.15591.76403.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Oct 2009 16:25:30 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> Add hpsa driver for HP Smart Array controllers.
> 
> This driver supports a subset of HP Smart Array Controllers.
> It is a SCSI alternative to the cciss driver.

Does it support all the devices which cciss supports?

IOW, do we have a plan here to remove the cciss driver or must we
maintain both drivers indefinitely?

