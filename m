Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZBSWsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZBSWsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbZBSWsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:48:42 -0500
Received: from smtp3.ono.com ([62.42.230.176]:58589 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754825AbZBSWsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:48:42 -0500
Date: Thu, 19 Feb 2009 23:48:38 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Status of ext4 tools
Message-ID: <20090219234838.4c06c98b@werewolf.home>
X-Mailer: Claws Mail 3.7.0cvs67 (GTK+ 2.15.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I'm following the threads on ext4, but I have a couple questions, and
perhaps this can be a thread to bookmark with all the answers people
need... ;)

I have migrated some partitions to ext4 in several boxes (even my /home
on the One...and works fast), but...

- Where is the 'official' source for e4defrag ?
- I've read that e4defrag needs in-kernel support.
  Is it already in mainline ?
  From what kernel version ?
- I have seen that some distros refer to a package called 'e4fsprogs'.
  Does that thing exist ? Where ?
- Booting:
  - There seem to be patches for grub
    http://lists.openwall.net/linux-ext4/2008/11/19/8
    to boot ext4
  - and a Google SoC called 'grub4ext4'.
   -and there is also grub2 (ext4 support in svn).
  What would you recommend ?

That's what I miss to move completely to ext4 ;)

Apart from that, it works pretty fine.
The thing that most surprised me was that after the needed fsck, it had
converted files with contiguous blocks to big extents ;). Nice.

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.28.2-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed Jan
