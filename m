Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXJUJZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXJUJZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXJUJZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:25:24 -0400
Received: from main.gmane.org ([80.91.229.2]:35498 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXJUJZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:25:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: [OOPS] 2.6.23.1 in ext2/pdflush (tainted)
Date: Sun, 21 Oct 2007 15:25:05 +0600
Message-ID: <471B1AF1.5060300@ums.usu.ru>
References: <20071021083612.GC7554@hindley.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: mark@hindley.org.uk
X-Gmane-NNTP-Posting-Host: 90.150.227.81
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
In-Reply-To: <20071021083612.GC7554@hindley.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hindley wrote:

> Unfortunately the kernel is tainted by madwifi modules. As it
> is used headless as a wireless router, I can't remove them.

You can. That's what ath5k is for. The driver is available from svn, see 
http://madwifi.org/browser/ath5k/trunk (aka "svn co 
http://svn.madwifi.org/ath5k/trunk"), or from git.

-- 
Alexander E. Patrakov

