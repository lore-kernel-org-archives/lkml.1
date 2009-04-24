Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZDXJ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZDXJ5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZDXJ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:57:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:5648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZDXJ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=VBbqwTfH+71YjO9o1MbPdYuuZg+GAmvU+m6LOI5R9Zr0v4rzsa745I4AR8vzqWdm6m
         h2SZpHyA24JKWtQNKnczOZqX+pYlhVB4bQ60GiHdDdnjFD/HHI0Oo+HPXbIXecdaLtCs
         CjFu7ldtMbDgG73sXJFpsV2Fz74i6/zlKga/U=
MIME-Version: 1.0
Date: Fri, 24 Apr 2009 11:57:35 +0200
X-Google-Sender-Auth: c1ef312d54eef063
Message-ID: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
Subject: Suggestions request for speed-up kernel compilation
From: Alessio Igor Bogani <abogani@texware.it>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Sorry for my bad English.

I'm a kernel newbie and I would be very happy to receive some tips
about kernel compilation from experienced developers.

I have recently elaborated some trivial patches. For each one I have
done a build test at minimum and I find myself spend a lot of time
waiting my Core Duo to accomplish this task. Make is a very smart tool
but after a git pull or a git fetch origin/git reset --hard origin it
can't help as desired.

Unfortunately I don't have a clustered compilation farm under my control. :-)

Anyone can suggest me how mitigate that issue?

Tips, RTFM, links will be appreciated as long as referred to real used
technique.

Thanks in advance and sorry for stupid question.

Ciao,
Alessio
