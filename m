Return-Path: <linux-kernel-owner+w=401wt.eu-S934272AbXCWJQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbXCWJQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 05:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422748AbXCWJQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 05:16:07 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41525 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934272AbXCWJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 05:16:06 -0400
Date: Fri, 23 Mar 2007 10:15:41 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Amedee Van Gasse <amedee@amedee.be>
cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-Reply-To: <1173122352.19761.33.camel@saruman>
Message-ID: <Pine.LNX.4.64.0703231014410.5030@twin.jikos.cz>
References: <1173122352.19761.33.camel@saruman>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007, Amedee Van Gasse wrote:

> It _appears_ that the bug reports started after an update of 
> bluez-utils, but this remains to be confirmed. It could be 
> coincidence/temporal correlation (which does not imply causation).

Hi Amedee,

did you have time to confirm whether this started to happen after 
bluez-utils update, as you stated in the mail above some time ago?

Thanks,

-- 
Jiri Kosina
