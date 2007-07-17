Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbXGQNK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbXGQNK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXGQNKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:10:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXGQNKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:10:17 -0400
Date: Tue, 17 Jul 2007 15:10:14 +0200
From: Karel Zak <kzak@redhat.com>
To: List util-linux-ng <util-linux-ng@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] util-linux-ng 2.13-rc2
Message-ID: <20070717131014.GA28982@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



The second util-linux-ng 2.13 release candidate is available at

    ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/


v2.13-rc2 changelog:
~~~~~~~~~~~~~~~~~~~

readprofile:
    - also search for __stext in readprofile  [Mike Frysinger]
build-sys:
    - remove libtool  [Karel Zak]
cal:
    - add test code  [Karel Zak]
fdisk:
    - check returns in fdisk from partition changes  [Mike Frysinger]
    - do not complain about regular files  [H. Peter Anvin]
    - when generating a DOS disk label, give it an ID  [H. Peter Anvin]
login-utils:
    - remove deprecated sigsetmask() from wall  [Karel Zak]
    - remove unwanted newlines from wall  [Karel Zak, Matthias Koenig]
lomount.c:
    - don't use mlockall if CRYPT_NONE [Masatake YAMATO]
misc-util:
    - new rtcwake command [Bernhard Walle]
mount:
    - add acl option documentation for ext3 and reiserfs [Matthias Koenig]
schedutils:
    - fix chrt docs and pid=0 usage [Matthias Koenig]
    - prefer SYS_ioprio_{set,get} from glibc to hardcoded version [Karel Zak]
sys-utils:
    - add arch(1) back to the official tree (see ReleaseNotes
            for more details)  [Karel Zak]
whereis:
    - add lib64 paths  [Karel Zak]


 Feedback and bug reports, as always, are welcomed.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
