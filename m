Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbXKZL5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbXKZL5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 06:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXKZL52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 06:57:28 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35292 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbXKZL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 06:57:27 -0500
Message-ID: <474AB4A3.8050802@davidnewall.com>
Date: Mon, 26 Nov 2007 22:27:23 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Josh Goldsmith <joshin@hotmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
References: <BLU103-DAV550703C13BE5EF0DDF51AD6740@phx.gbl>
In-Reply-To: <BLU103-DAV550703C13BE5EF0DDF51AD6740@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Goldsmith wrote:
> The problem comes when I try to untar a large file (in this case 
> linux-2.6.23.tar.bz2).  Regardless if I kill off every other process, 
> eventually the oom-killer will appear and kill either the tar or the 
> shell.

What's the actual command you are executing?
