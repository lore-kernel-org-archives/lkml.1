Return-Path: <linux-kernel-owner+w=401wt.eu-S1161206AbXCAXCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161206AbXCAXCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161202AbXCAXCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:02:08 -0500
Received: from terminus.zytor.com ([192.83.249.54]:36785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161197AbXCAXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:02:07 -0500
Message-ID: <45E75B61.3080106@zytor.com>
Date: Thu, 01 Mar 2007 15:01:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Someone please turn on the http protocol on git.kernel.org!
References: <45E7260F.8000908@freescale.com>
In-Reply-To: <45E7260F.8000908@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> I see we now have a dedicate machine for the git server.  That's great.  
> How about turning on the http protocol so that those of use behind a 
> firewall can clone trees?

> I get this:
> 
> $ git-clone http://git.kernel.org/pub/scm/git.git
> Initialized empty Git repository in /temp/git/.git/
> Cannot get remote repository information.
> Perhaps git-update-server-info needs to be run there?

Don't use the git server for that, please.  Use 
http://www.kernel.org/pub/scm/... instead.

	-hpa

