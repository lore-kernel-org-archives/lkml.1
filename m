Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbZDBIT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbZDBIT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZDBITk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:19:40 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:38218 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbZDBITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:19:39 -0400
Message-ID: <49D47515.6070602@wpkg.org>
Date: Thu, 02 Apr 2009 10:19:33 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel versions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have noticed that when compiling various kernel versions with same
> .config file
> (this is .config file from generic 2.6.27-7 kernel that works)
> on same machine the results are unpredictable :) Sometimes machine just
> shuts down during the compilation

Shuts down during compilation? Or freezes?

It mostly means hardware problems.


> and in most cases it won't boot.

And what does kernel say during booting and where it breaks / stop booting?


-- 
Tomasz Chmielewski
http://wpkg.org

