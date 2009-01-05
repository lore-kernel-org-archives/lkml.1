Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZAEUOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZAEUOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZAEUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:14:33 -0500
Received: from mail.die-tessuns.de ([83.125.40.159]:43924 "EHLO
	chewie.lokal.die-tessuns.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752621AbZAEUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:14:32 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2009 15:14:32 EST
X-Spam-score: -4.0
Message-ID: <4962680E.1030306@die-tessuns.de>
Date: Mon, 05 Jan 2009 21:05:34 +0100
From: Martin Tessun <martin.tessun@die-tessuns.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: A SuSE riddle
References: <20090105185225.GH6165@tatooine.rebelbase.local>
In-Reply-To: <20090105185225.GH6165@tatooine.rebelbase.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

markus reichelt schrieb:
> Hi,
> 
> this goes out to the SusE folks in here: 
> 
> What the heck is needed to get one's hands on the contents of
> 
> kernel-source-2.6.27.7-9.1.i586.rpm
> 
> The usual tools fail.
> 
> Downloaded from http://ftp.uni-bayreuth.de/linux/opensuse/distribution/11.1/repo/oss/suse/i586/
> 
> 
> And why not provide a .CAB for it? Seems to work better anyway.
> 

I don't see your problem:

S | Name          | Typ   | Version      | Arch   | Repository
--+---------------+-------+--------------+--------+-----------------------
i | kernel-source | Paket | 2.6.27.7-9.1 | x86_64 | Haupt-Repository (OSS)
v | kernel-source | Paket | 2.6.27.7-9.1 | i586   | Haupt-Repository (OSS)

12 | repo_1                           | Haupt-Repository (OSS)
       | Ja        | Ja            | 99        | yast2  |
http://download.opensuse.org/distribution/11.1/repo/oss/       |


So there are the kenels for both Architectures available.

Regards,
Martin

BTW.: I think zypper *is* the standard-tool for SuSE-Updates and you
should go to the SuSE-Kernel-Mailing-List with that problem.
