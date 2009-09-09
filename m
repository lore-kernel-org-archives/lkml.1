Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZIIPJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZIIPJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZIIPJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:09:42 -0400
Received: from bosmailout19.eigbox.net ([66.96.187.19]:52198 "EHLO
	bosmailout19.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZIIPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:09:41 -0400
X-Greylist: delayed 2421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 11:09:41 EDT
X-EN-OrigOutIP: 10.20.18.9
X-EN-IMPSID: eeVL1c0050BkY8i0000000
Message-ID: <4AA7BC05.7050507@jaysonking.com>
Date: Wed, 09 Sep 2009 09:30:29 -0500
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: gregkh@suse.de
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/48] 2.6.27.32-stable review
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 66.139.154.210
X-EN-OrigHost: adsl-66-139-154-210.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
 >I thought the second one would solve the problem.
 >
 >What happened here, I took the upstream patch, was it incorrect? If so,
 >was there a patch, also upstream, that fixed this problem?
 >
 >totally confused,

No. The upstream patch was not incorrect, but it was incompletely 
applied to 2.6.27. The missing line is not missing in the upstream 
patch. The replacement for the patch I sent earlier puts the line back in.

Jayson R. King

(sorry if I am dropping anyone from CC. I am not subscribed to LKML)


