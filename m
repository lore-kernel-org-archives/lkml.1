Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZAEENX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZAEENX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 23:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbZAEENP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 23:13:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:50455 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZAEENO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 23:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=eTwmWLK8eLpa5Uw7kiNrv8+m9Nt+M3WY9gLWtpTcrCGfxjrZXlg0Fr1oC2eN5RPcvK
         Z+mbirKpkid7+leUsCUV8MZCJNk71nCFJ1HJyCPHHpvxwzSbhHYggKV7USCFLvdoDWif
         hPhWOXOwcvL7BfwVLNg0iZWk5Y7eK0rZzycjQ=
Message-ID: <b6a2187b0901042013o2bc295b6r8e7ab92f29528d30@mail.gmail.com>
Date: Mon, 5 Jan 2009 12:13:12 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: iwl4965 cannot use "ap auto" on latest 2.6.28/29?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using latest linux git 2.6.28/29? and it seems the iwl4965 can't
use "iwconfig ap auto" to associate with the hidden AP. On
2.6.28-stable, it's working fine.

Linus, it is possible for you bump up the SUBLEVEL or EXTRAVERSION to
differentiate from the 2.6.28-stable version.

Thanks,
Jeff
