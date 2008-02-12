Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbYBLTkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbYBLTkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762076AbYBLTkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:40:12 -0500
Received: from main.gmane.org ([80.91.229.2]:34249 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYBLTkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:40:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Chris Nolan <chrisonthelists@cenolan.com>
Subject: [PATCH] hid, 2.6.23 - add support for new macbook and apple aluminum
 keyboard "fn" key
Date: Tue, 12 Feb 2008 19:36:54 +0000
Message-ID: <fosskb$klp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cnolan.demon.co.uk
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list.

Seeking feedback for this patch which adds support for the "fn" key on 
the new macbook (3,1) and apple aluminum keyboard.

I have tested this with kernel 2.6.23 (both 2.6.23.9 and 2.6.23.15) 
under Fedora 8 and it seems to work for me.

The original patch was created by Martin Szulecki (of mactel-linux) and 
  Chris Irwin. I can't take any credit - I've just found that it works 
and would like to see it tested and committed upstream if possible.

I am linking to the patch because a) its quite long, and b) I am not 
sure how to prevent thunderbird from wrapping the lines and I'd hate to 
annoy the list with some malformed garbage.

Patch is here:

https://bugzilla.redhat.com/attachment.cgi?id=294650

Regards
Chris

