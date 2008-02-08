Return-Path: <linux-kernel-owner+w=401wt.eu-S934040AbYBHAop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbYBHAop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYBHAoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:44:32 -0500
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:34090 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYBHAob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:44:31 -0500
Date: Thu, 7 Feb 2008 19:44:25 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       stern@rowland.harvard.edu, pavel@ucw.cz
Subject: Re: [GIT PATCH] suspend patches for 2.6.25-rc0
Message-ID: <20080208004425.GB29980@cs.cmu.edu>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	stern@rowland.harvard.edu, pavel@ucw.cz
References: <200802011820.56693.lenb@kernel.org> <20080207222713.GA20549@cs.cmu.edu> <200802080014.41638.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802080014.41638.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 12:14:40AM +0100, Rafael J. Wysocki wrote:
> I haven't revert the changes.  It's only moved the notifier chain calls from
> the ioctls to open/release in user.c .

Ah my bad, sorry about the false alarm.

Jan
