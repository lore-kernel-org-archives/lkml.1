Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYAESYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYAESYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 13:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbYAESX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 13:23:56 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:22686 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbYAESXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:23:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=PAXe+9dgy9nKX30yiMIVsX4T3r1ICU5DHiOEEGxNlpJeugdOkpKsG6gjlaFrpvqAV4zcA+Mut5fIS7AM8tGs1MYl9I/V+nLDLpjvnZHadOXPFPKkCJL+UnzdP/4qC4gFa/jJNfvGbtG31Qn0TATPNT+N78yGNAVM9NzIwrHcfXc=
Date: Sat, 5 Jan 2008 12:23:38 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13.1-rc2
Message-ID: <20080105122338.7c526c8a@vader.jdub.homelinux.org>
In-Reply-To: <20080105013121.c8bf01ed.akpm@linux-foundation.org>
References: <20080102211052.GC23824@petra.dvoda.cz>
	<20080105013121.c8bf01ed.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 01:31:21 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 2 Jan 2008 22:10:52 +0100 Karel Zak <kzak@redhat.com> wrote:
> 
> > 
> > 
> >  The second util-linux-ng 2.13.1 release candidate is available at
> > 
> >     ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/
> > 
> 
> Interesting.  Thanks.  Which distros are using this, or plan to do so?

Fedora switched quite a bit ago.  That shouldn't be a surprise given
the maintainer's affiliation :)

josh
