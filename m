Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbZIPNaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbZIPNaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZIPNaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:30:15 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:43249 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZIPNaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:30:14 -0400
Message-ID: <4AB0E843.8010808@wpkg.org>
Date: Wed, 16 Sep 2009 15:29:39 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linuxhippy@gmail.com
Subject: Re: Howto switch off ext4's delayed allocation?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just happend again to me.
> After the intel driver crashed my system, the source-file I was
> working on was empty. Fourtunatly eclipse has a history-log.

Never had your /etc/passwd and /etc/shadow zeroed? Lucky you...


> Isn't there a way to switch off the more "dangerous" optimizations in ext4?
> I already searched howto do this, but from what I've seen there was
> only discussion about providing a switch for disabling delayed
> allocation, but it was never done?

Documentation/filesystems/ext4.txt?


-- 
Tomasz Chmielewski
http://wpkg.org


