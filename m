Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZDSOSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZDSOSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 10:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbZDSOSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 10:18:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:41839 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091AbZDSOSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 10:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=UrQCxQkPk/gJjHaJv92ZpZGs/rC1NC86qglxzjp94tJRhAlrmxKkLyHt6HVpdOGrzs
         Dj1fCyLESiDCnTRnRxNPPwZk/NKtSxnOsmswTenlq3/++/+a2oJT6Fl8mef7IWdSaYBl
         RafpcoBpx+6By6F9xld7xrddLH06CeMewKiwo=
MIME-Version: 1.0
Date: Sun, 19 Apr 2009 15:18:33 +0100
Message-ID: <ef37ea20904190718p2d5164efib231cc9f468854c2@mail.gmail.com>
Subject: how to build a vmlinux with debugging symbols?
From: Task Struct From Hell <taskstructfromhell@googlemail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

List,

I am trying to figure out why one of my servers crashed, I have some C
and ASM knowledge and back in the 2.2 days I even wrote a few modules
to the Linux kernel, but now I am completely lost in the 2.6 kbuild
and as such, can someone point into some documentation on debugging
vmcore's and how to enable debugging symbols so using gdb wont be as
painful? :-)

---
Cheers,
TSFH
