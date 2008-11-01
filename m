Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbYKAHOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbYKAHOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 03:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYKAHNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 03:13:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYKAHNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 03:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=dHOG4mq+8+h6raVlO7el3+bo4IWn+P4U/gusrSeVu9EIvTX1lTypIo9/WSy7jmCGD5
         CeGB9EtIOm8rJkrmvrZcrswMSjbpB7aPnkgp9+F1DW9rO2p27cJ/bxMh17P8IjTdUIpV
         /1LahDppq8lodTNfvehJ8j8NElKnqUjKA7jqg=
Message-ID: <804dabb00811010013t2594a03fw3cef35a2f39a4f80@mail.gmail.com>
Date: Sat, 1 Nov 2008 15:13:49 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: removal of fs/proc/inode-alloc.txt
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find it weird, that a text file should exists among the directories
of C and header files.   If it is a legitimate documentation it should
go into Documentation subdirectory, correct?   Or if it is so short
like it currently is, go into some C file.

Anyway I don't understand anything about this text file, and from its history:

http://www.google.com/search?q=site%3Alkml.org+%22inode-alloc.txt%22&btnG=Google+Search

I don't see its purpose here.

Can someone comment on its history, can it be removed?

-- 
Regards,
Peter Teoh
