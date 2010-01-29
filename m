Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896Ab0A2GgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0A2GgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539Ab0A2GgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:36:12 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55318 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab0A2GgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dLjMVw1NwuUO69nH45YMHFN2ASDILIXf4eoPJIOr0S6QANU6gZtbt7cTuPwOTR6KQ8
         mUscAdATahbVA910bLdlp0TSAKj33wEoasGwI36vPgjtVs3Tsl6vGUrWMDxb77TMx0a8
         Tt12j3fGJc8SRjgYfgjHHURgA1njk2QmYHBmw=
Date: Thu, 28 Jan 2010 22:36:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, jy0922.shim@samsung.com,
       mika.kuoppala@nokia.com, peter.hutterer@who-t.net
Subject: Re: [PATCH 1/2] input: mt: add the ABS_MT_PRESSURE event
Message-ID: <20100129063606.GD4177@core.coreip.homeip.net>
References: <1264718569-9772-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264718569-9772-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 11:42:48PM +0100, Henrik Rydberg wrote:
> For pressure-based multi-touch devices, a direct way to send sensor
> intensity data per finger is needed. This patch adds the ABS_MT_PRESSURE
> event to the MT protocol.
> 
> Requested-by: Yoonyoung Shim <jy0922.shim@samsung.com>
> Requested-by: Mika Kuoppala <mika.kuoppala@nokia.com>
> Requested-by: Peter Hutterer <peter.hutterer@who-t.net>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Both applied, thank you Henrik.

-- 
Dmitry
