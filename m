Return-Path: <linux-kernel-owner+w=401wt.eu-S2992657AbXCBR0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992657AbXCBR0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992655AbXCBR0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:26:08 -0500
Received: from gw.goop.org ([64.81.55.164]:59960 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992657AbXCBR0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:26:06 -0500
Message-ID: <45E85E2C.1090704@goop.org>
Date: Fri, 02 Mar 2007 09:26:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: FN <zzzz444@ml1.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: module builds need improvement / top Makefile not good enough
References: <1172855662.23830.1177403935@webmail.messagingengine.com>
In-Reply-To: <1172855662.23830.1177403935@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FN wrote:
>    a) version rollback that causes timestamp rollback
Ugh. Broken.

> it's better to be able to do 
> gnumake -C /lib/modules/`uname -r`/build M=`pwd` MYMAKE=mymake modules 
>   

Patches accepted.

    J
