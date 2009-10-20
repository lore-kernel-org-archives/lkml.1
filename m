Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZJTBnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZJTBnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 21:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbZJTBnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 21:43:55 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:44655 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbZJTBny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 21:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iMnr1KAWARRR+a8ts6nOpgITZuk6VvB/BIBHNtz/bw9H6BZpQ6VviXYuq/oumPVzx/
         ovGjUEALNjaGHVTyTCaQ/1CUkQC8LJPBP9D9CrmCJEOWczbbwUOQGINYMn3PU+Ejfaic
         WF5ap023E85Yq5MBaBFlFFm5kmvHGURTqAgPc=
Date: Mon, 19 Oct 2009 18:38:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: =shaohua.li@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] ACPI: dock: convert sysfs attributes to an
	attribute_group
Message-ID: <20091020013844.GB24370@core.coreip.homeip.net>
References: <20091019211132.5412.80438.stgit@bob.kio> <20091019211424.5412.15540.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019211424.5412.15540.stgit@bob.kio>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 03:14:24PM -0600, Alex Chiang wrote:
> As suggested by Dmitry Torokhov, convert the individual sysfs
> attributes into an attribute group.
> 
> This change eliminates quite a bit of copy/paste code in the
> error handling paths.
> 

Looks good to me, thank you for making the changes.

-- 
Dmitry
