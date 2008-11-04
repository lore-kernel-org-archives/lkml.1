Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbYKDQZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbYKDQZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYKDQYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:24:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:52363 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYKDQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:24:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=uOq2H5vjI46NiePA3ghZdJrlNJnlf0a06VjEabyPdZtEziEK1Flwlqh15EQZoJV5bP
         u66rk5jdEgAHX/zQ3cVXCIvpCUf46vaNa5UtH+sIxJIiBx4mPiaoj8s99DxYL0SGVlEu
         cTl9ZqQlmQjk0SvmXttTHDusBIZnf09aIyyL0=
Message-ID: <49107728.3040907@gmail.com>
Date: Tue, 04 Nov 2008 18:24:08 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: gregkh@suse.de
CC: charrer@alacritech.com, linux-kernel@vger.kernel.org
Subject: [STAGING] slicoss - update README
Content-Type: multipart/mixed;
 boundary="------------020505010805090303050004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020505010805090303050004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The README file incorrectly states that I can test this drivers. Sadly I 
can not as I don't have this kind of hardware.

Signed-off-by: Lior Dotan <liodot@gmail.com>

--------------020505010805090303050004
Content-Type: text/plain;
 name="slicoss-readme.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slicoss-readme.patch"

--- b/drivers/staging/slicoss/README	2008-11-04 11:53:12.688821205 +0200
+++ a/drivers/staging/slicoss/README	2008-11-04 12:20:07.618138129 +0200
@@ -14,6 +14,5 @@ TODO:
 
 Please send patches to:
         Greg Kroah-Hartman <gregkh@suse.de>
-and Cc: Lior Dotan <liodot@gmail.com> and Christopher Harrer
-<charrer@alacritech.com> as well as they are also able to test out any
-changes.
+and Cc: Christopher Harrer <charrer@alacritech.com> as well as he is also able
+to test out any changes.

--------------020505010805090303050004--
