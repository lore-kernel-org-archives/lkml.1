Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYEHXzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYEHXzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYEHXyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:54:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:32244 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYEHXyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EgZLC6ik/WsFwxUYJf2FVbtwNZ0z99R80FG59lnPKQ3wEeGIEwSIv2FbBsf0IxNHN6h8ZZBRLefhPZmrnZNF6G2z5DmkM1pwKRve8hrO3WJXsd6T2ITzGjWSdrPOGW2aG+VWwFjF7AYCmq1qH2xrkb1lH2/gbcKKPkeSLf9e7dY=
Message-ID: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com>
Date: Fri, 9 May 2008 09:54:52 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       "Gary Hade" <garyhade@us.ibm.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: regression fixed by using pci=rom
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A user just reported this bug

http://bugs.freedesktop.org/show_bug.cgi?id=15523

He says using pci=rom fixes the regression, do we truly have to start
booting machines with this, sucks to be a distro..

Dave.
