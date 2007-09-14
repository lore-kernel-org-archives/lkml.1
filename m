Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbXINK33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbXINK33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXINK3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:29:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbXINK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:29:19 -0400
Date: Fri, 14 Sep 2007 03:29:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-box <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com,
       linux-kernel@vger.kernel.org, sumant.patro@lsi.com
Subject: Re: PATCH 2/4] scsi: megaraid_sas -- add module param fast_load
Message-Id: <20070914032914.ca96117e.akpm@linux-foundation.org>
In-Reply-To: <1189513694.6082.9.camel@dhcp-75-534.se.lsil.com>
References: <1189513694.6082.9.camel@dhcp-75-534.se.lsil.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 08:28:14 -0400 linux-box <bo.yang@lsi.com> wrote:

> Driver will skip physical devices scan for the first time if the fast_load is set

When preparing changelogs it is often good to describe _why_ the change is
being made, as well as what the change does.

It may be obvious to some people why users of this driver might want to use
this feature, but I don't have clue why you did this.

