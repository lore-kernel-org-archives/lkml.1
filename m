Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYHWSa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYHWSa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 14:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYHWSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 14:30:12 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:55081 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYHWSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 14:30:11 -0400
Message-ID: <48B0569E.6030907@hypersurf.com>
Date: Sat, 23 Aug 2008 11:27:42 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: compile testing:  cpufreq stats driver?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	When I tried building my cpufreq driver into the kernel, the
cpufreq stats driver quit working? Anyone know if I screwed something up?
Or is this normal (2.6.26)?

	Also, I thought, apparently incorrectly, That module parameters
became boot parameters when the module was built in to the kernel?

kevin
