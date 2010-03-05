Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab0CEWTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:19:53 -0500
Received: from cicero-fbr1.cybercity.dk ([212.242.40.5]:64789 "EHLO
	cicero-fbr1.cybercity.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0CEWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:19:52 -0500
Message-ID: <4B918341.7030107@ritz.dk>
Date: Fri, 05 Mar 2010 23:18:41 +0100
From: Jonas Ritz <jonas@ritz.dk>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

guys...

Some stages of development of software requires the change API.

fx. the initial phase or clean up phase.

The use of software (or development of dependent software) requires a 
predictable API.

To do both effectively, the community needs to invent a tool that keeps 
track of what version userspace code the kernel needs, and a formalized 
directory structure for staging/oldies code.
