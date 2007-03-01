Return-Path: <linux-kernel-owner+w=401wt.eu-S965515AbXCATO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515AbXCATO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXCATO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:14:26 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:42204 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965515AbXCATO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:14:26 -0500
Message-ID: <45E7260F.8000908@freescale.com>
Date: Thu, 01 Mar 2007 13:14:23 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Someone please turn on the http protocol on git.kernel.org!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I see we now have a dedicate machine for the git server.  That's great.  How about turning 
on the http protocol so that those of use behind a firewall can clone trees?

I get this:

$ git-clone http://git.kernel.org/pub/scm/git.git
Initialized empty Git repository in /temp/git/.git/
Cannot get remote repository information.
Perhaps git-update-server-info needs to be run there?

I'm using git 1.5.0.2.  I have the same problem with git 1.4.4.

When I use my web browser to view http://git.kernel.org/pub/scm/git.git, I get an error 404.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale
