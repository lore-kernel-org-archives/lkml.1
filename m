Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZANKxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZANKxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbZANKxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:53:42 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:24768 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZANKxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:53:41 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 05:53:40 EST
Message-ID: <496DC1C6.7090307@turknet.net.tr>
Date: Wed, 14 Jan 2009 12:43:18 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, chris.mason@oracle.com
Subject: Btrfs Snapshot Removal And General Project Status
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2009 10:43:23.0232 (UTC) FILETIME=[EC57BE00:01C97634]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

For the last few days, I was playing with btrfs. It looks really very 
promising and fantastic! :-)
Thanks for everybody who involved with this amazing file system project! 
;-) Now, I play with snapshots. Creating snapshot is a breeze. 
Recovering from snapshots work very well without any problems as far as 
I tried. But; when I tried to remove the snapshot directories, I got an 
error message that says : "cannot remove directory `snap1': Directory 
not empty". But actually, it is empty. After that, I googled a bit and 
found at "http://btrfs.wiki.kernel.org/index.php/Project_ideas" at 
"Removal Snapshots" section, it states that it needs to be implement. 
But, it's unclear which state this feature is now.

It could be perfect to prepare a document that shows the current status 
(completed, blah-blah % completed etc.) of the features,general status 
of the project and maybe deadlines of feature implementions. Like : 
"next release will have blah-blah features" etc.


BTW, is there any temporary way to remove these snapshot directories 
before this "Remove Snapshot" feature implemented ? ;-)

Tarkan ERIMER


