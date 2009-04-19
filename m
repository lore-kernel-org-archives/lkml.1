Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbZDSPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbZDSPVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 11:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZDSPVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 11:21:06 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:59215 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbZDSPVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 11:21:05 -0400
X-Greylist: delayed 1060 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Apr 2009 11:21:04 EDT
Date: Sun, 19 Apr 2009 17:03:20 +0200
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Problems with default ACLs over NFS
Message-ID: <20090419150320.GA4517@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón <jamagallon@ono.com> wrote:

> With strace, I get this:
>
> mkdir("kk", 0777)                       = -1 EINVAL (Invalid
> argument)

I've got the exact same Problem but with 2.6.19.1 and a Linux (2.6.27something)
NFS Server. Any patch which addresses this issue?

Sven

-- 
The main thing to note is that when you choose open source you don't
get a Windows operating system.
                                  (from http://www.dell.com/ubuntu)
/me is giggls@ircnet, http://sven.gegg.us/ on the Web
