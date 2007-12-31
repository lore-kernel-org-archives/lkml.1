Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbXLaHmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbXLaHmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 02:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXLaHl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 02:41:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:41485 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXLaHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 02:41:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=evAbP4VG1uHopWGuE4H4hJnbe8n2JnOjaVHQO7vuYojGnc/XtTmsHyGAdo8plhfR54h61OvnbbBd/SEihlqMTSK+UptrfETr3PSdo09I2Q+iMFUbNOZxhTIpSSgLRs2PQ6Us9/UFBUbbhSBIH9FzTHiFiLsq3WWH0hJU7xfveII=
Message-ID: <e5bfff550712302335ie96e143g55c93e984fba6aaa@mail.gmail.com>
Date: Mon, 31 Dec 2007 08:35:29 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Git Mailing List" <git@vger.kernel.org>,
       msysGit <msysgit@googlegroups.com>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] qgit-2.1 and qgit-1.5.8
Cc: "Pavel Roskin" <proski@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

  new versions of Qt4 based qgit-2.1 and stable Qt3 based qgit-1.5.8
have been released.

Download tarballs from
http://sourceforge.net/project/showfiles.php?group_id=139897

Or directly from git repositories

git://git.kernel.org/pub/scm/qgit/qgit.git   (qgit-1.5.8)
git://git.kernel.org/pub/scm/qgit/qgit4.git  (qgit-2.1)


Stable qgit-1.5.8 has only maintenance fixes, not a lot indeed, it
happens to be already very stable.

New stuff is in qgit-2.1, you can find a detailed changelog at

http://git.kernel.org/?p=qgit/qgit.git;a=shortlog


After popular request, this time I have packaged qgit-2.1 in a nice
Windows installer (Inno Setup based) downloadable from the above
sourceforge link, so that our Window's friends can try qgit without
worrying about compilers, Qt libraries and other geeky things ;-)

Window installer will ask you to locate the msysgit directory. Indeed
msysgit is the only supported git distribution under Windows, because
Cygwin has some issues and is also muuuch slower.

So the only prerequisite is to have already installed msysgit
(http://code.google.com/p/msysgit/)


Happy new year 2008 !
Marco
