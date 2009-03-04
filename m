Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZCDXlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZCDXlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZCDXlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:41:46 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:58253 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZCDXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gYksYiuy0ot80sIKDx3OxrzyIGWrUnkligAXMe2oK660fN9yQaDST4IoedDAEScQh3
         0J8dimfdtTKHMPRc0ys+1hPfVXKmvHjmR/2xiN460u8EYIXJhA79taDtFEM82PDJaYz7
         Xg4LBoGjfxhtx5mLwyKeyXDB4I+rHUKhQk0Eo=
Message-ID: <49AF11AB.8040605@gmail.com>
Date: Thu, 05 Mar 2009 00:41:31 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: feature-removal-schedule.txt updated ??
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

code is still there or file is not updated ?


$ grep ^When  Documentation/feature-removal-schedule.txt | egrep -v "2009|2010|2.6.3[0-9]"
When:   2.6.29
When:   July 2007
When:   December 2008
When:   November 2005
When:   August 2006
When:   before 2.6.19
When:   October 2008
When:   July 2008
When:   August 2007
When:   February 2008
When: Dec 2008
When:   July 2008
When:   2.6.27
When:   2.6.29
When:   After the only user (hal) has seen a release with the patches
When: 2.6.29

-thanks-

regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
