Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXCYITu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXCYITu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbXCYITu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:19:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36080 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159AbXCYITt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:19:49 -0400
Date: Sun, 25 Mar 2007 00:19:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       sailer@us.ibm.com
Subject: Re: [Patch 4/7] integrity: IMA integrity_measure() support
Message-Id: <20070325001946.5c939d0c.akpm@linux-foundation.org>
In-Reply-To: <1174666190.11149.4.camel@localhost.localdomain>
References: <1174666190.11149.4.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 12:09:50 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +void create_htable(void);

I notice a bit of a tendency in these patches to create ill-chosen global
identifiers.  Please review the whole patchset for that.
