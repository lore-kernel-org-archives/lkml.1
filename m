Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYLEVDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYLEVDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYLEVC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:02:58 -0500
Received: from vps1.tull.net ([66.180.172.116]:52044 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752198AbYLEVC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:02:58 -0500
Date: Sat, 6 Dec 2008 08:02:53 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
       "Kevin D. Kissell" <kevink@paralogos.com>,
       Lucas Woods <woodzy@gmail.com>, linux-mips@linux-mips.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix incorrect use of loose in vpe.c
Message-ID: <20081205210253.GD5957@mail.local.tull.net>
References: <S24119814AbYLEAhF/20081205003705Z+5882@ftp.linux-mips.org> <20081205155654.GA2765@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205155654.GA2765@linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 03:56:54PM +0000, Ralf Baechle wrote:
> Thanks, applied.  Note that the address you used for Kevin Kissel to post
> your patch is no longer valid.

Yep. By default the get_maintainers.pl script which I used trawls through
'git log' to find everybody who was involved in a commit in each affected
file during the last 12 months. Kevin signed off commit b618336aac14 from
his old address.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
