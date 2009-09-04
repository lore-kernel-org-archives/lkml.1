Return-Path: <linux-kernel-owner+w=401wt.eu-S933759AbZIDQfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759AbZIDQfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932747AbZIDQfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:35:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58145 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZIDQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:35:19 -0400
Date: Fri, 4 Sep 2009 17:35:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: Document the sysfs interface
Message-ID: <20090904163520.GE1576@sirena.org.uk>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252081568-6000-1-git-send-email-mjg@redhat.com>
X-Cookie: YOW!!!  I am having fun!!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 12:26:07PM -0400, Matthew Garrett wrote:

> The sysfs interface to the RTC class drivers is currently undocumented.
> Add some basic documentation defining the semantics of the fields.

> Signed-off-by: Matthew Garrett <mjg@redhat.com>

> +SYSFS INTERFACE
> +---------------

Wouldn't this be better placed under Documentation/ABI?

