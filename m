Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbXJZTTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbXJZTTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbXJZTTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:19:44 -0400
Received: from mail.syneticon.net ([213.239.212.131]:43498 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXJZTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:19:43 -0400
Message-ID: <47223DC9.5060204@wpkg.org>
Date: Fri, 26 Oct 2007 21:19:37 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible 2.6.23 regression - Disappearing disk space
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Ausmus wrote:

> OK, false alarm, this is definitely a userpsace (or a user... :)
> problem - had a 12GB .xsession-errors file that I had deleted but was
> still being held open - now I just have to determine why I have a 12GB
> .xsession-errors file... :(

Surely, .xsession-errors was 12GB large because of a 2.6.23 regression ;)


-- 
Tomasz Chmielewski
http://blog.wpkg.org
