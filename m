Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZLDNi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZLDNi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZLDNi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:38:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbZLDNiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:38:25 -0500
Subject: RE: [PATCH] [SCSI] megaraid_sas: remove sysfs dbg_lvl world
	writeable permissions
From: "Bryn M. Reeves" <bmr@redhat.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Eugene Teo <eteo@redhat.com>, Casey Dahlin <cdahlin@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       DL-MegaRAID Linux <megaraidlinux@lsi.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Anand Gadiyar <gadiyar@ti.com>,
       Jiri Kosina <jkosina@suse.cz>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3B78D7030@cosmail02.lsi.com>
References: <1259767064-13738-1-git-send-email-cdahlin@redhat.com>
	 ,<4B170174.5030805@redhat.com>
	 <4B6A08C587958942AA3002690DD4F8C3B78D7030@cosmail02.lsi.com>
Content-Type: text/plain
Date: Fri, 04 Dec 2009 13:38:29 +0000
Message-Id: <1259933909.32500.0.camel@breeves.fab.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 08:01 -0700, Yang, Bo wrote:
> How do you turn on poll_mode_io?

Write to the file as root?

Bryn.


