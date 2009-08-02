Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZHBIQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZHBIQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZHBIQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:16:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:51879 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZHBIQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OCucpRhoG3IroP/6UvsTYRhWE9h0nMbD+GSq1LdI1W1iS+I0hcFfPeMnSqKoZMx+ZP
         sGaD/2/pyOuruFxaZByiNgrWTWuGG3wnK6dCIgpPi/bF8QirX4mJC5CJK3ai+hOjmblj
         jFfl2/FiHw7UxKn9zKkf5F9Oc/qR4uih65gPE=
Date: Sun, 2 Aug 2009 16:16:13 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: touchpad stuck sometimes
Message-ID: <20090802081612.GA14646@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My touchpad sometimes will stuck for a while, and then it will be ok.

I can see kernel message like this:

[ 1293.426227] psmouse.c: GlidePoint at isa0060/serio1/input0 lost synchronization, throwing 2 bytes away.
[ 1293.969357] psmouse.c: resync failed, issuing reconnect request

Hardware is dell e5400, kernel version: 2.6.31-rc5

--
Regards
dave
